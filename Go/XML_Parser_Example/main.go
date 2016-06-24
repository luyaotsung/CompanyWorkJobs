package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

// <Document>
// <Element>
// <ATCCODE>A10BA02</ATCCODE>
// <馬偕碼>25703</馬偕碼>
// <起日>2016/6/2 上午 12:00:00</起日>
// <迄日>2113/12/28 上午 12:00:00</迄日>
// <用途>糖尿病用藥</用途>
// <名稱>METFORMIN</名稱>
// <商品名-中文>克醣錠500公絲</商品名-中文>
// <商品名-英文>UFORMIN TABLETS 500MG</商品名-英文>
// <藥品外觀>白色長橢圓形扁錠，一面中央有一刻痕並有"MF"及"1"字樣</藥品外觀>
// <用藥須知>常見不良反應為腸胃不適(如噁心、腹瀉)飯後服用可減少此作</用藥須知>
// <飲食方面注意事項>1.確實遵守醫師和營養師的運動和膳食建議，且食用健康膳食。 2.酒會影響血糖，服藥期間避免飲酒。</飲食方面注意事項>
// <藥品副作用與處置方式>
// 1.最常見但較輕微的副作用包括：腹瀉、噁心及胃不適，與食物併服會降低這些副作用。 2.偶爾會引起維它命B12吸收不良，導致貧血及周邊神經症狀。 3.最嚴重但較少發生的副作用就是“乳酸中毒”（不尋常的疲憊感、嚴重的嗜睡、眩暈、肌肉疼痛、呼吸困難或急促、心跳過慢或不規則、體液滯留）須立即就醫。
// </藥品副作用與處置方式>
// <圖片更新日期>2014/10/18 上午 11:02:55</圖片更新日期>
// <簡稱>■糖 Metformin 500mg(UFORMIN*)</簡稱>
// <商品名>■UFORMIN * 500mg Tab 克醣錠</商品名>
// </Element>
// <Version>20160621V1</Version>
// </Document>

// Query is an exported type that
type Query struct {
	Version string     `xml:"Version"`
	Element []drugInfo `xml:"Element"`
}

type drugInfo struct {
	ATCCODE        string `xml:"ATCCODE"`
	MMHCode        string `xml:"馬偕碼"`
	DateFrom       string `xml:"起日"`
	DateEnd        string `xml:"迄日"`
	Usage          string `xml:"用途"`
	NameCht        string `xml:"商品名-中文"`
	NameEng        string `xml:"商品名-英文"`
	DrugLook       string `xml:"藥品外觀"`
	DurgGuide      string `xml:"用藥須知"`
	Precautions    string `xml:"注意事項"`
	DrugSideEffect string `xml:"藥品副作用與處置方式"`
	ImageUdateDate string `xml:"圖片更新日期"`
	NameShort      string `xml:"簡稱"`
	Name           string `xml:"商品名"`
}

func detectEmptyElement(input string) string {
	if len(strings.TrimSpace(input)) > 0 {
		return input
	}
	return " "
}

func main() {
	// curl --data "sDate=2000/01/01"  https://wapps.mmh.org.tw/WS_Drug/WebService.asmx/GetDrugInfo_DI
	resp, err := http.PostForm("https://wapps.mmh.org.tw/WS_Drug/WebService.asmx/GetDrugInfo_DI",
		url.Values{"sDate": {"2000/01/01"}})

	if err != nil {
		fmt.Println("Error XML Server Error :", err)
	}

	defer resp.Body.Close()
	xmlFile, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error Read XML from resp.Body :", err)
	}

	var q Query
	err = xml.Unmarshal(xmlFile, &q)
	if err != nil {
		fmt.Println("Error XML Decode :", err)
		return
	}

	fmt.Println()

	for _, DrugInfo := range q.Element {
		fmt.Printf("\n[ATTCCODE]%s [馬偕碼]%s [簡名]%s \n[商品名-英文]%s \n[副作用]\n%s \n ",
			detectEmptyElement(DrugInfo.ATCCODE),
			detectEmptyElement(DrugInfo.MMHCode),
			detectEmptyElement(DrugInfo.Name),
			detectEmptyElement(DrugInfo.NameEng),
			detectEmptyElement(DrugInfo.DrugSideEffect))
	}
}
