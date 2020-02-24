const puppeteer = require ('puppeteer')
const expect = require ('chai').expect

const config = require('../lib/config')
const click = require('../lib/helper').click
const typeText = require('../lib/helper').typeText
const loadUrl = require('../lib/helper').loadUrl
const waitForText = require('../lib/helper').waitForText
const pressKey = require('../lib/helper').pressKey
const shouldExist = require('../lib/helper').shouldExist

const utils = require('../lib/utils')

describe('My first puppeteer test', function () {
    let browser
    let page

    before( async  function f() {
        browser = await  puppeteer.launch({
            headless: config.isHeadless,
            showMo: config.slowMo,
            devtools: config.isDevtools,
            timeout: config.launchTimeout,
        })
        page = await browser.newPage()
        await page.setDefaultTimeout(config.waitingTimeout)
        await page.setViewport({
            width: config.viewportHeight,
            height: config.viewportWidth,
        })
    })
    
    after(async function f() {
        await browser.close()
    })
    
    it('my first test setup', async () => {
        await loadUrl(page,config.baseUrl)
        await shouldExist(page,'#nav-search')

        const url = await page.url()
        const title = await page.title()

        expect(url).to.contains('dev')
        expect(title).to.contains('Community')
    })

    it('browser reload', async()=>{
        await page.reload()
        await shouldExist(page,'#page-content')

        await waitForText(page,'body','WRITE A POST')

        const url = await page.url()
        const title = await page.title()

        expect(url).to.contains('dev')
        expect(title).to.contains('Community')
    })
    it('click method ', async () => {
        await loadUrl(page, config.baseUrl)
        await click(page,'#write-link')

        await shouldExist(page, '.registration-rainbow')
    })

    it('summit searchbox', async () => {
        await loadUrl(page, config.baseUrl)
        await typeText(page, utils.generateNumbers()  ,'#nav-search')
        await page.waitFor(3000)
        await pressKey(page, 'Enter')
        await page.waitForSelector('#articles-list')
    })
});
