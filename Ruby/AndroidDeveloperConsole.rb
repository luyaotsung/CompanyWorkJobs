#
# Argument
# 1 => User Name
# 2 => Password
# 3 => Brand Name


require "rubygems"
require "selenium-webdriver"
require "chromedriver-screenshot"

loginID = ARGV[0]
loginPW = ARGV[1]

text = [
         #"Acer",
        #"Anydata",
        #"Archos",
        #"Asus",
        #"BYD",
        #"Barnes and Noble",
        #"BlackBerry",
        #"CJSC Explay",
        #"Cellon",
        #"Compal",
        #"Coolpad",
        #"Dell",
        #"Digi-In",
        #"Doro",
        #"ECS",
        #"Enspert",
        #"FLY",
        #"Foxconn International Holdings Limited",
        "Fuhu",
        "Fujitsu",
        "Fujitsu Toshiba Mobile Communications Limited",
        "Gigabyte",
        "Google",
        "Google ATAP",
        "HP",
        "Haier",
        "Hisense",
        "Hon Hai Precision Industry Co., Ltd.",
        "Huawei",
        "Intel",
        "KT Tech",
        "Kyocera Corporation",
        "LGE",
        "Lava International",
        "Lenovo Mobile",
        "Longcheer",
        "MSI",
        "Mediatek",
        "Micromax",
        "Mobiwire",
        "Motorola",
        "NEC",
        "NVidia",
        "Nikon",
        "Oneplus",
        "Oppo",
        "Panasonic Corporation",
        "Panasonic Mobile Communications",
        "Pantech",
        "Pegatron",
        "Philips Electronics",
        "Positivo",
        "Qualcomm Inc",
        "Quanta Corporation",
        "Ragentek",
        "SHARP",
        "SK Telesys",
        "Samsung",
        "Sony",
        "Sony Ericsson",
        "Spice",
        "Symphony Teleca",
        "TCT Mobile Limited (Alcatel)",
        "Teleepoch",
        "Toshiba Corporation",
        "Vertu",
        "Vestel",
        "Wind River",
        "Xiaomi",
        "ZTE",
        "iRIver",
        "Unknown"
   ]

text.each do |line|
   brandName = line

   puts " ----------- Brand Name is #{brandName} ----------------"

   #driver = Selenium::WebDriver.for :firefox
   #
   #
   driver = Selenium::WebDriver.for :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate --purge-memory-button --memory-model=low]
   driver.navigate.to "https://play.google.com/apps/publish/"
   driver.manage.timeouts.implicit_wait = 30
   #driver.manage.window.maximize

   # wait for a specific element to show up
   wait = Selenium::WebDriver::Wait.new(:timeout => 60) # seconds


   ## Login Process
   wait.until { driver.find_elements(:xpath => "//*[@id='Email']" ) }
   loginMail = driver.find_elements(:xpath => "//*[@id='Email']")
   loginMail[0].send_keys("#{loginID}")

   wait.until { driver.find_elements(:xpath => "//*[@id='next']" ) }
   loginMail = driver.find_elements(:xpath => "//*[@id='next']")
   loginMail[0].click

   wait.until { driver.find_elements(:xpath => "//*[@id='Passwd']" ) }
   loginMail = driver.find_elements(:xpath => "//*[@id='Passwd']")
   loginMail[0].send_keys("#{loginPW}")

   wait.until { driver.find_elements(:xpath => "//*[@id='signIn']" ) }
   loginMail = driver.find_elements(:xpath => "//*[@id='signIn']")
   loginMail[0].click

   sleep 10

   ## Reach to APK page
   driver.navigate.to "https://play.google.com/apps/publish/?dev_acc=01878399894313558671#ApkPlace:p=com.aiqidi.nemo"


   ## Show list page
   wait.until { driver.find_elements(:link_text => "See list" ) }
   loginMail = driver.find_elements(:link_text => "See list" )
   loginMail[0].click

   wait.until { driver.find_elements(:xpath => "/html/body/div[8]/div/div/div[2]/div/header/h3" ) }


   showList = driver.find_elements(:partial_link_text => "Show all")
   showList.each do |list|
      list.click
   end

   brandItem = driver.find_elements(:xpath => "//h3[contains(text(),'#{brandName}')]").first
   deviceList = brandItem.find_elements(:xpath => "../ol/li")
   deviceList.each do |device|

      labelSapn = device.find_elements(:xpath => "label/span")
      checkboxSapn = device.find_element(:xpath => "checkbox/span")
      checkbox = device.find_element(:xpath => "checkbox")

      checkbox.location_once_scrolled_into_view
      ariaChecked = checkbox.attribute('aria-checked')

      if labelSapn.length > 1
         labelName = labelSapn[0].text
         labelName += " - "
         labelName += labelSapn[1].text
      else
         labelName = labelSapn[0].text
      end

      if ariaChecked == "false"
         puts "** #{brandName} ** #{labelName} ** SUPPORT"
         checkboxSapn.click
      else
         puts "** #{brandName} ** #{labelName} "
      end

   end

   saveBTN = driver.find_element(:xpath => "/html/body/div[8]/div/div/div[2]/div/footer/button")
   unless !saveBTN.attribute("disabled").nil?
      saveBTN.click

   end

   sleep 10

   driver.quit

   puts " ----------- End  #{brandName} ----------------"

end

####
##wait.until { driver.find_elements(:xpath => "/html/body/div[8]/div/div/div[2]/div/header/h3" ) }
##lists = driver.find_elements(:css => "ol>li")
##puts "Get All ol>li , length is #{lists.length}"
##
##list_showAll = driver.find_elements(:partial_link_text => "Show all")
##puts "Get All showall , length is #{list_showAll.length}"
##
##showAll = driver.find_element(:xpath => "/html/body/div[8]/div/div/div[2]/div/div/ol/li[1]/a")
##showAll.click
##
##checkBox = driver.find_elements(:xpath => "//*[@data-device-id='acer_T02']/checkbox" )
##checkBox[0].click


#lists.each do |value|
#   puts "Value is -> #{value.attribute('data-device-id')} "
#
#   unless value.attribute('data-device-id').nil?
#      puts "Current Value is -> #{value.attribute('data-device-id')} "
#      findValue = value.attribute('data-device-id')
#      checkBox = driver.find_elements(:xpath => "//*[@data-device-id='#{findValue}']/label/span" )
#
#      puts "1=> #{value.attribute('data-device-id')} , 2=>#{checkBox[0].text} , 3=>#{checkBox[1].text}}"
#   end
#
#
#end


##puts "Starting "
##wait.until { driver.find_elements(:xpath => "/html/body/div/div/div/div/div[3]/div[1]/div[2]/div/div[1]/div/span" ) }
##element = driver.find_elements(:xpath => "//div[@type='button']" )
##
##firstCheck = 0
##firstTotal = element.length
##firstName = ""
##
##while firstCheck < firstTotal do
##
##
##   wait.until { driver.find_elements(:xpath => "/html/body/div/div/div/div/div[3]/div[1]/div[2]/div/div[1]/div/span" ) }
##   firstElement = driver.find_elements(:xpath => "//div[@type='button']" )
##
##   firstName = firstElement[firstCheck].text
##   firstElement[firstCheck].click
##
##   puts "FIRST check #{firstCheck} , totoal #{firstTotal} , name #{firstName}"
##
##
##   wait.until { driver.find_element(:xpath =>  "/html/body/div/div/div/div/p" )  }
##
##   element = driver.find_elements(:xpath =>  "//span[@type='button']")
##
##
##   if element.length == 0
##      puts " We don't have disese "
##      driver.navigate.to "http://162.222.176.0:8080/encyclopedia"
##   else
##
##      checkNextPage = driver.find_elements(:xpath => "/html/body/div/div/div/div/div[4]/a" )
##
##      if checkNextPage.length >= 0
##         puts "==> Total Value of array is #{element.length} , Page : #{checkNextPage.length}  "
##      else
##         puts "==> Total Value of array is #{element.length}  "
##      end
##
##      pageCurrent = 0
##      pageTotal = checkNextPage.length
##      if pageTotal == 0
##         pageURLSource = driver.current_url + "&page="
##         pageTotal = 1
##      else
##         pageURLSource = checkNextPage[0].attribute('href').chomp("1")
##      end
##
##      while pageCurrent < pageTotal do
##
##         puts " ***  Currnt Page : #{pageCurrent} , Total Page #{pageTotal} "
##
##         puts " *** #{pageURLSource}#{pageCurrent}  "
##         driver.navigate.to "#{pageURLSource}#{pageCurrent}"
##
##         wait.until { driver.find_element(:xpath =>  "/html/body/div/div/div/div/p" )  }
##         element = driver.find_elements(:xpath =>  "//span[@type='button']")
##
##         check = 0
##         total = element.length
##
##         while check < total do
##            wait.until { driver.find_element(:xpath =>  "//span[@type='button']" )  }
##
##            element = driver.find_elements(:xpath =>  "//span[@type='button']"  )
##
##            element[check].click
##
##            wait.until { driver.find_element(:xpath =>  "//div/h2" )  }
##
##            name = driver.find_element(:xpath => "//div/h1" )
##
##            diseaseNumber = ( pageCurrent * 10 ) + check + 1
##
##            puts "====> value : #{diseaseNumber} , disease : #{name.text}"
##
##            shname = "./screenshot/" + sprintf("%05d", firstCheck.to_s) + "-" + sprintf("%05d",diseaseNumber.to_s) + ".png"
##            driver.save_screenshot(shname )
##
##            driver.navigate.to "#{pageURLSource}#{pageCurrent}"
##
##            check += 1
##
##         end
##         pageCurrent += 1
##      end
##
##   end
##
##   driver.navigate.to "http://162.222.176.0:8080/encyclopedia"
##   firstCheck += 1
##
##end
### driver.save_screenshot("./page_final.png")


