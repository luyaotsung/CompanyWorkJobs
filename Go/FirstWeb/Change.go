package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
	//	"reflect"
	"github.com/astaxie/session"
	_ "github.com/astaxie/session/providers/memory"
	"regexp"
)

func ChoiceHandler(w http.ResponseWriter, r *http.Request, title string, File_List []os.FileInfo) {
	//File_List, _ := ioutil.ReadDir("./Original")

	sess := globalSessions.SessionStart(w, r)

	s_createtime := sess.Get("createtime")
	if s_createtime == nil {
		sess.Set("session_createtime", time.Now().Unix())
	} else if (s_createtime.(int64) + 360) < (time.Now().Unix()) {
		globalSessions.SessionDestroy(w, r)
		sess = globalSessions.SessionStart(w, r)
	}

	s_count := sess.Get("Session_Count")
	if s_count == nil {
		sess.Set("Session_Count", 0)
		s_count = 0
	} else {
		s_count = s_count.(int) + 1

		if s_count.(int) > (len(File_List) - 1) {
			s_count = 0
		}
		sess.Set("Session_Count", s_count)
	}

	params := &Page{Title: title, Image_Name: File_List[s_count.(int)].Name()}
	//fmt.Println(reflect.TypeOf(File_List))

	fmt.Printf("In Choice , count : %d \n", s_count.(int))

	ts, _ := template.New("html").Parse("<h1> {{.Title}} </h1><div>" +
		"<form action=\"/Save/{{.Title}}\" method=\"POST\">" +
		"<button type=\"submit\" name=\"Result\" value=\"High\">High Qaulity</button>" +
		"<button type=\"submit\" name=\"Result\" value=\"Low\">Low Quality</button>" +
		"<button type=\"submit\" name=\"Result\" value=\"Bad\">All Bad</button>" +
		"</form>" +
		"<img src=\"/Images/{{.Image_Name}}\" style=\"max-width: 95%; maz-height: 95%\" > {{.Image_Name}}</img></div>")
	ts.Execute(w, params)
}

func SaveHandler(w http.ResponseWriter, r *http.Request, title string, File_List []os.FileInfo) {
	Save_Status := r.FormValue("Result")

	sess := globalSessions.SessionStart(w, r)

	s_count := sess.Get("Session_Count")

	Size := len(File_List)
	File_Name := File_List[s_count.(int)].Name()
	fmt.Printf("Title : %s , File Name : %s , Resutl : %s , Len of Slice : %d , Count Value : %d  \n", title, File_Name, Save_Status, Size, s_count.(int))
	http.Redirect(w, r, "/Choice/"+title, http.StatusFound)
}

type Page struct {
	Title      string
	Image_Name string
}

//Set a global seesion variable
var globalSessions *session.Manager

//Initial global session
func init() {
	globalSessions, _ = session.NewManager("memory", "gosessionid", 3600)
	go globalSessions.GC()
}

var validPath = regexp.MustCompile("^/(Choice|Save)/([a-zA-Z0-9]+)$")

func makeHandler(fn func(http.ResponseWriter, *http.Request, string, []os.FileInfo), fl []os.FileInfo) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		m := validPath.FindStringSubmatch(r.URL.Path)

		//fmt.Printf("From %s Count is %d \n", m[1], count)
		fmt.Printf("From %s \n", m[1])

		fn(w, r, m[2], fl)
	}
}

func main() {
	File_List, _ := ioutil.ReadDir("./Original")
	http.HandleFunc("/Choice/", makeHandler(ChoiceHandler, File_List))
	http.HandleFunc("/Save/", makeHandler(SaveHandler, File_List))
	http.Handle("/Images/", http.StripPrefix("/Images/", http.FileServer(http.Dir("./Original"))))
	err := http.ListenAndServe(":22442", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
