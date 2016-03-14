#!/usr/bin/env groovy

@Grapes([

		@Grab('org.gebish:geb-core:0.12.2'),
		@Grab('org.seleniumhq.selenium:selenium-chrome-driver:2.42.0'),
		//@Grab('org.seleniumhq.selenium:selenium-firefox-driver:2.52.0')

])

import geb.Browser
import org.openqa.selenium.chrome.ChromeDriver

System.setProperty('webdriver.chrome.driver', '/Users/elilu/Coding/GEB/chromedriver')

def keywords = args.join(' ')
def LoginMail = "alfa.ho.htc@gmail.com"
def LoginPassword = "87654321"

driver = {
	new ChromeDriver()
}

Browser.drive {

	config.reportsDir = new File(".")

		go "http://xdsi-dev-tyghirb.aiqidii.com/tygh/" 

		println "go Website" 

		waitFor {
			$('h3').size() > 0
		}

		$('button').each {
			println "=>${it.text()}<="

		}

	println "finish Wait h3"

		$("button").has("div").click()

		println "Click First Page "


		waitFor {
			$("#login_field_systemLoginemail").size() > 0
		}

	println "Check Login Page Done" 

		$("#login_field_systemLoginemail").value(LoginMail)
		$("#login_field_systemLoginpassword").value(LoginPassword)

		println "Finish Inject ID/PW" 

		$("button",text: "登入").click()

		println "Finish Login" 

		report "screenshoi.xxxt"

		sleep(5000)

		$('span').each {
			println "=>${it.text()}<="

		}


}.quit()
