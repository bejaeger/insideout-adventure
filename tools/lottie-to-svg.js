
const fs = require("fs");
const renderSvg = require("lottie-to-svg");


// export lottie as svg
// add to miro
// copy image
// from clipboard in preview
// export as png


const animationData = JSON.parse(fs.readFileSync(`assets/lottie/chilldude.json`, "utf8"));

renderSvg(animationData).then(svg => {
  fs.writeFileSync(`chilldude.svg`, svg, "utf8");
});