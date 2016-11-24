package main

import (
	"bytes"
	"fmt"
	"image"
	"image/png"
	"os"
	"time"

	"github.com/tebeka/selenium"
)

func sshot(wd selenium.WebDriver, name string) {
	screenshot, _ := wd.Screenshot()
	img, _, _ := image.Decode(bytes.NewReader(screenshot))

	out, err := os.Create(name)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = png.Encode(out, img)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

}

// Errors are ignored for brevity.
func main() {
	// FireFox driver without specific version
	// *** Add gecko driver here if necessary (see notes above.) ***
	caps := selenium.Capabilities{
		"browserName": "firefox",
	}
	wd, err := selenium.NewRemote(caps, "http://localhost:4444/wd/hub")
	if err != nil {
		panic(err)
	}

	defer wd.Quit()
	// Get simple playground interface
	wd.Get("http://qiita.com/utahta/items/17afea7933624371504c")
	wd.SetImplicitWaitTimeout(60 * time.Second)
	wd.SetAsyncScriptTimeout(60 * time.Second)
	wd.SetPageLoadTimeout(15 * time.Second)
	wd.MaximizeWindow("")

	sshot(wd, "001.png")
	//page1Buttons, _ := wd.FindElements(selenium.ByXPATH, "//div[@type='button']")
	//sshot(wd, "001.png")
	//fmt.Println("page1Button number is ", len(page1Buttons))
	//page1Buttons[2].Click()
	//page2Buttons, _ := wd.FindElements(selenium.ByXPATH, "//span[@type='button']")
	//fmt.Println("page2Button number is ", len(page2Buttons))
	//sshot(wd, "002.png")
	//page2Buttons[2].Click()
	//sshot(wd, "003.png")

}
