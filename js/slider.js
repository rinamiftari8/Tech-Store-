const kornizaEBrendeve = [...document.querySelectorAll(".kornizaEBrendeve")];
const shkoDjathtas = [...document.querySelectorAll(".shkoDjathtas")];
const shkoMajtas = [...document.querySelectorAll(".shkoMajtas")];

kornizaEBrendeve.forEach((item, i) => {
  let containerDimensions = item.getBoundingClientRect();
  let containerWidth = containerDimensions.width;

  shkoDjathtas[i].addEventListener("click", () => {
    item.scrollLeft += containerWidth;
  });

  shkoMajtas[i].addEventListener("click", () => {
    item.scrollLeft -= containerWidth;
  });

  // Touch gestures for mobile
  let startX = 0;
  let scrollLeft = 0;

  item.addEventListener("touchstart", (e) => {
    startX = e.touches[0].pageX - item.offsetLeft;
    scrollLeft = item.scrollLeft;
  });

  item.addEventListener("touchmove", (e) => {
    if (!startX) return;
    const x = e.touches[0].pageX - item.offsetLeft;
    const walk = (x - startX) * 2; // Scroll speed
    item.scrollLeft = scrollLeft - walk;
  });

  item.addEventListener("touchend", () => {
    startX = 0;
  });
});
