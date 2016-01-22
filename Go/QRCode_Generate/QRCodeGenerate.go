package main

import (
	"bytes"
	"fmt"
	"image"
	"image/png"
	"os"
	"runtime"

	"code.google.com/p/rsc/qr"
)

func main() {

	// maximize CPU usage for maximum performance
	runtime.GOMAXPROCS(runtime.NumCPU())

	// generate the link or any data you want to
	// encode into QR codes
	// in this example, we use an example of making purchase by QR code.
	// Replace the stuff2buy with yours.

	//stuff2buy := "stuffpurchaseby?userid=" + randomStr + "&issuer=SomeBigSuperMarket"
	stuff2buy := "1101100011;2;04;測試患者;A12****789;500101;;1041204;IC;28;A12;4280#4659#25000#7806#49300#7100#;5684;;AC339291G0;1;QHS;PO;28;AB30119100;1;QID;PO;112;BC23221100;1;QD AM;PO;28;AC444501G0;1;BID;PO;56;BC256961G0;1;QHS;PO;28;BC21571100;1;QD AM;PO;28;"

	// Encode stuff2buy to QR codes
	// qr.H = 65% redundant level
	// see https://godoc.org/code.google.com/p/rsc/qr#Level

	code, err := qr.Encode(stuff2buy, qr.H)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	imgByte := code.PNG()

	// convert byte to image for saving to file
	img, _, _ := image.Decode(bytes.NewReader(imgByte))

	//save the imgByte to file
	out, err := os.Create("./QRImg.png")

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = png.Encode(out, img)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// everything ok
	fmt.Println("QR code generated and saved to QRimg1.png")

}
