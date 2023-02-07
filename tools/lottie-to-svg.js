
// export lottie as svg
// add to miro
// copy image
// from clipboard in preview
// export as png


const fs = require("fs");
const renderSvg = require("lottie-to-svg");


const animationData = JSON.parse(fs.readFileSync(`assets/lottie/walkinggirl.json`, "utf8"));

renderSvg(animationData).then(svg => {
  fs.writeFileSync(`walkinggirl.svg`, svg, "utf8");
});
