package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/httputil"
)

type ResponseJSON struct {
	Method string `json:"Method"`
	Name   string `json:"Name"`
}

type FileUpload struct {
	Name        string `json:"filename"`
	Description string `json:"filedescription"`
	Data        string `json:"base64"`
	Type        string `json:"filetype"`
	Size        int    `json:"filesize"`
	Key         int    `json:"key"`
}

func FileHandler(w http.ResponseWriter, req *http.Request) {
	switch req.Method {
	case "POST":
		fmt.Println("File Handler :: POST  ")

		// Mirror r.body
		var bodyBytes []byte
		if req.Body != nil {
			bodyBytes, _ = ioutil.ReadAll(req.Body)
		}
		req.Body = ioutil.NopCloser(bytes.NewBuffer(bodyBytes))
		bodyString := string(bodyBytes)
		fmt.Println(bodyString)

		// Dump http response

		b, _ := httputil.DumpRequest(req, false)
		log.Println(string(b))

		// Decode JSON
		var rJSON FileUpload

		err := json.NewDecoder(req.Body).Decode(&rJSON)
		if err != nil {
			log.Printf("Error: %v \n", err)
		}

		//{
		//	"filesize": 54836 (bytes),
		//	"filetype": "image/jpeg",
		//	"filename": "profile.jpg",
		//	"Key": "9999",
		//	"base64":   "/9j/4AAQSkZJRgABAgAAAQABAAD//gAEKgD/4gIctcwIQA..."
		//}
		// If must field is empty Return Error Type
		var feedbackString string
		if rJSON.Data == "" {
			feedbackString = "Error !! Content of file is empty"
		} else {
			result, _ := base64.StdEncoding.DecodeString(rJSON.Data)
			fileName := fmt.Sprintf("/home/eli/Templates/Test/%s", rJSON.Name)
			fmt.Println(fileName)
			ioutil.WriteFile(fileName, result, 0644)
			feedbackString = "Date is current"
		}
		buf, _ := json.Marshal(feedbackString)
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(200)
		w.Write(buf)
	default:
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(400)
	}
	fmt.Println(" ")
}

func StringHandler(w http.ResponseWriter, req *http.Request) {
	//getProject := req.URL.Path[len("/Method1/"):]
	//fmt.Println(getProject)
	switch req.Method {
	case "POST":
		fmt.Println("String Handler :: POST ")

		// Mirror r.body
		var bodyBytes []byte
		if req.Body != nil {
			bodyBytes, _ = ioutil.ReadAll(req.Body)
		}
		req.Body = ioutil.NopCloser(bytes.NewBuffer(bodyBytes))
		bodyString := string(bodyBytes)
		fmt.Println(bodyString)

		// Decode JSON
		var rJSON ResponseJSON
		err := json.NewDecoder(req.Body).Decode(&rJSON)
		if err != nil {
			fmt.Printf("Error: %v \n", err)
			log.Printf("Error: %v \n", err)
		}

		// If must field is empty Return Error Type
		var feedbackString string
		if rJSON.Method == "" || rJSON.Name == "" {
			feedbackString = "Error !! Some filed is empyt"
		} else {
			feedbackString = "All Data is Current"
		}
		buf, _ := json.Marshal(feedbackString)
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST")
		w.Write(buf)

	case "GET":
		fmt.Println("String JSON Handler :: Get ")
		line := ResponseJSON{
			Method: "Client Get",
			Name:   "Only Json Response Get",
		}
		buf, err := json.Marshal(line)
		fmt.Println("Content of JSON: ", line)
		if err != nil {
			fmt.Println(err.Error())
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST")
		w.Write(buf)
	default:
		w.WriteHeader(400)
	}
	fmt.Println(" ")
}

func main() {

	fmt.Println("Start Server :22442  ")
	http.HandleFunc("/string/", StringHandler)
	http.HandleFunc("/file/", FileHandler)
	http.ListenAndServe(":22442", nil)

}
