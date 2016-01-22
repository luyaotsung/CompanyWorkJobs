package main

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"runtime"

	"code.google.com/p/rsc/qr"
	_ "github.com/mattn/go-sqlite3"
)

type ResponseJSON struct {
	Method string `json:"Method"`
	Name   string `json:"Name"`
}

//CREATE TABLE DATA(
//	SN INTEGER PRIMARY KEY AUTOINCREMENT,
//	NAME TEXT NOT NULL,
//	DESCRIPTION TEXT,
//	SIZE INTEGER NOT NULL,
//	TYPE TEXT,
//	DATA BLOB NOT NULL
//);
// CMD : CREATE TABLE DATA(SN INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,DESCRIPTION TEXT,SIZE INTEGER NOT NULL,TYPE TEXT,DATA BLOB NOT NULL);

type FileList struct {
	List []FileUpload
}

type FileUpload struct {
	SN          int    `json:"sn"`
	Name        string `json:"filename"`
	Description string `json:"filedescription"`
	Data        string `json:"base64"`
	Type        string `json:"filetype"`
	Size        int    `json:"filesize"`
}

func HandleErr(str string, err error) {
	if err != nil {

		log.Printf("Error(%s): %v \n", str, err)
		log.Fatal(err)
	}
}

func WriteData(file *FileUpload) {

	fmt.Println("Write Data to SQLite")

	db, err := sql.Open("sqlite3", "./db.sql")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	InjectValue := fmt.Sprintf(" \"%s\" ,\"%s\" ,\"%d\" ,\"%s\", \"%s\" ", file.Name, file.Description, file.Size, file.Type, file.Data)
	_, err = db.Exec("insert into DATA(NAME,DESCRIPTION,SIZE,TYPE,DATA)values ( " + InjectValue + ")")
	if err != nil {
		log.Fatal(err)
	}
}

func GetFile(id string) *FileUpload {

	fmt.Println("Get Data From SQLite")

	db, err := sql.Open("sqlite3", "./db.sql")
	HandleErr("GetList::SQL.open", err)

	defer db.Close()

	queryString := fmt.Sprintf("select * from DATA where SN = %s", id)
	fmt.Println(queryString)

	rows, err := db.Query(queryString)
	HandleErr("GetFile::db.Query", err)

	defer rows.Close()

	var file FileUpload
	for rows.Next() {
		var sn, size int
		var name, description, typename, data string
		// CMD : CREATE TABLE DATA(SN INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,DESCRIPTION TEXT,SIZE INTEGER NOT NULL,TYPE TEXT,DATA BLOB NOT NULL);
		rows.Scan(&sn, &name, &description, &size, &typename, &data)
		//fmt.Println(sn, name, size)
		file = FileUpload{
			SN:          sn,
			Name:        name,
			Description: description,
			Type:        typename,
			Size:        size,
			Data:        data,
		}
	}
	return &file
}

func GetList() *FileList {
	var file FileList
	fmt.Println("<< Get List for SQLite >>")

	db, err := sql.Open("sqlite3", "./db.sql")
	HandleErr("GetList::SQL.open", err)

	defer db.Close()

	rows, err := db.Query("select SN, NAME, DESCRIPTION, TYPE, SIZE from DATA")
	HandleErr("GetList::db.Query", err)

	defer rows.Close()

	for rows.Next() {
		var sn, size int
		var name, description, typename string
		rows.Scan(&sn, &name, &description, &typename, &size)
		result := FileUpload{
			SN:          sn,
			Name:        name,
			Description: description,
			Type:        typename,
			Size:        size,
		}
		file.List = append(file.List, result)
	}
	return &file
}

func FileHandler(w http.ResponseWriter, req *http.Request) {
	switch req.Method {
	case "GET":
		var returnJSON []byte
		fmt.Println("File Handler :: GET  ")
		targetDownloadID := req.URL.Path[len("/file/"):]
		if targetDownloadID == "" {
			fmt.Println("Get List")
			list := GetList()
			returnFileList, err := json.Marshal(list)
			HandleErr("FileHandle::returnFileList", err)

			returnJSON = returnFileList
		} else {
			fmt.Println("Get File by ID :", targetDownloadID)
			file := GetFile(targetDownloadID)
			returnFileInfo, err := json.Marshal(file)
			HandleErr("FileHandle::returnFileInfo", err)
			returnJSON = returnFileInfo
		}
		//fmt.Println(" << Original JSON String >>", string(returnJSON))
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(200)
		w.Write(returnJSON)
	case "POST":
		fmt.Println("File Handler :: POST  ")

		////  Mirror r.body
		//var bodyBytes []byte
		//if req.Body != nil {
		//	bodyBytes, _ = ioutil.ReadAll(req.Body)
		//}
		//req.Body = ioutil.NopCloser(bytes.NewBuffer(bodyBytes))
		//bodyString := string(bodyBytes)
		//fmt.Println(bodyString)

		//// Dump http response
		//b, _ := httputil.DumpRequest(req, false)
		//log.Println(string(b))

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
			WriteData(&rJSON)
			//result, _ := base64.StdEncoding.DecodeString(rJSON.Data)
			//fileName := fmt.Sprintf("/home/eli/Templates/Test/%s", rJSON.Name)
			//ioutil.WriteFile(fileName, result, 0644)
			//feedbackString = "Date is current"
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

type MMH_Drug_QRCode struct {
	Hospital_ID       string  `json:"hospitalid"`
	Prescription_Type int     `json:"prescriptiontype"`
	Prescription_ID   string  `json:"prescriptionid"`
	Name              string  `json:"name"`
	ID                string  `json:"id"`
	Birthday          string  `json:"birthday"`
	Divisions         string  `json:"divisions"`
	Date              string  `json:"date"`
	Serial_Number     string  `json:"serialnumber"`
	Durg_Day          int     `json:"drugday"`
	Partial_Code      string  `json:"partialcode"`
	ICD9CM_Code       string  `json:"icd9cm"`
	Doctor_ID         string  `json:"doctorid"`
	Comment           string  `json:"comment"`
	Drug_ID           string  `json:"drugid"`
	Drug_Dosage       float32 `json:"drugdosage"`
	Drug_Frequencry   string  `json:"drugfrequency"`
	Drug_Count        float32 `json:"drugcount"`
}

type MMH_Drug_Information struct {
	Hospital_ID       []ID_List      `json:"hospitalid"`
	Prescription_Type []ID_List      `json:"prescriptiontype"`
	Prescription_ID   []ID_List      `json:"prescriptionid"`
	Divisions         []ID_List      `json:"divisions"`
	Partial_Code      []ID_List      `json:"partialcode"`
	ICD9CM_Code       []ID_List      `json:"icd9cm"`
	Doctor_ID         []ID_List      `json:"doctorid"`
	Drug_ID           []Drug_ID_List `json:"drugid"`
	Drug_Frequencry   []ID_List      `json:"drugfrequency"`
}

type ID_List struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Note string `json:"note"`
}

type Drug_ID_List struct {
}

type QRCode_Example struct {
	Data string `json:"data"`
}

func QRCodeHandler(w http.ResponseWriter, req *http.Request) {
	//getProject := req.URL.Path[len("/Method1/"):]
	//fmt.Println(getProject)
	switch req.Method {
	case "POST":
		fmt.Println("QRCodeHandler :: POST ")

		feedbackString := "Not Ready Now !!"
		buf, _ := json.Marshal(feedbackString)
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST")
		w.Write(buf)

	case "GET":

		fmt.Println("QRCodeJSON Handler :: Get ")

		var bodyBytes []byte
		if req.Body != nil {
			bodyBytes, _ = ioutil.ReadAll(req.Body)
		}
		req.Body = ioutil.NopCloser(bytes.NewBuffer(bodyBytes))
		bodyString := string(bodyBytes)
		fmt.Println(bodyString)

		// Decode JSON
		var rJSON QRCode_Example
		err := json.NewDecoder(req.Body).Decode(&rJSON)
		if err != nil {
			log.Printf("Error: %v \n", err)
		}
		// Usage : curl -H "Content-Type: application/json" -X GET -d '{"data":"1101100011;2;04;測試患者;A12****789;500101;;1041204;IC;28;A12;4280#4659#25000#7806#49300#7100#;5684;;AC339291G0;1;QHS;PO;28;AB30119100;1;QID;PO;112;BC23221100;1;QD AM;PO;28;AC444501G0;1;BID;PO;56;BC256961G0;1;QHS;PO;28;BC21571100;1;QD AM;PO;28;"}' http://10.116.136.13:22442/qrcode/abc.jpg -o cde.png

		// stuff2buy := "1101100011;2;04;測試患者;A12****789;500101;;1041204;IC;28;A12;4280#4659#25000#7806#49300#7100#;5684;;AC339291G0;1;QHS;PO;28;AB30119100;1;QID;PO;112;BC23221100;1;QD AM;PO;28;AC444501G0;1;BID;PO;56;BC256961G0;1;QHS;PO;28;BC21571100;1;QD AM;PO;28;"
		stuff2buy := rJSON.Data

		code, err := qr.Encode(stuff2buy, qr.M)

		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// everything ok
		fmt.Println("QR code generated")

		// line := ResponseJSON{
		// 	Method: "Client Get",
		// 	Name:   "Only Json Response Get",
		// }
		// buf, err := json.Marshal(line)
		// fmt.Println("Content of JSON: ", line)
		// if err != nil {
		// 	fmt.Println(err.Error())
		// 	http.Error(w, err.Error(), http.StatusInternalServerError)
		// }
		w.Header().Set("Content-Type", "image/png")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST")
		if _, err := w.Write(code.PNG()); err != nil {
			log.Println("unable to write image.")
		}
		// w.Write(imgByte)
	default:
		w.WriteHeader(400)
	}
	fmt.Println(" ")
}

func main() {

	// maximize CPU usage for maximum performance
	runtime.GOMAXPROCS(runtime.NumCPU())

	fmt.Println("Start Server :22442  ")
	http.HandleFunc("/string/", StringHandler)
	http.HandleFunc("/file/", FileHandler)
	http.HandleFunc("/qrcode/", QRCodeHandler)
	http.ListenAndServe(":22442", nil)

}
