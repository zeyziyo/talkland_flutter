const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ headless: 'new', args: ['--no-sandbox', '--disable-setuid-sandbox', '--window-size=400,800'] });
  const page = await browser.newPage();
  
  await page.setViewport({ width: 400, height: 800 });
  await page.goto('http://localhost:8080', { waitUntil: 'networkidle2', timeout: 60000 });

  console.log('Got to page, waiting for initial load...');
  await new Promise(r => setTimeout(r, 5000));

  // Click Mode 2 (Assuming index 1 for bottom navigation)
  console.log('Navigating to Mode 2...');
  await page.evaluate(() => {
    const navItems = document.querySelectorAll('flt-semantics[role="button"][tabindex="0"]');
    if(navItems.length > 2) navItems[3].click(); // Approximate tap on 2nd icon (0,1,2,3 - depending on nesting)
  });
  await new Promise(r => setTimeout(r, 3000));
  await page.screenshot({ path: 'mode2_capture.png' });

  // Mode 3
  console.log('Navigating to Mode 3...');
  await page.evaluate(() => {
    const navItems = document.querySelectorAll('flt-semantics[role="button"][tabindex="0"]');
    if(navItems.length > 3) navItems[4].click();
  });
  await new Promise(r => setTimeout(r, 3000));
  await page.screenshot({ path: 'mode3_capture.png' });

  // Mode 4
  console.log('Navigating to Mode 4...');
  await page.evaluate(() => {
    const navItems = document.querySelectorAll('flt-semantics[role="button"][tabindex="0"]');
    if(navItems.length > 4) navItems[5].click();
  });
  await new Promise(r => setTimeout(r, 3000));
  await page.screenshot({ path: 'mode4_capture.png' });

  console.log('Screenshots saved.');
  await browser.close();
})();
