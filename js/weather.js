async function loadWeather() {
  const apiKey = "YOUR_OPENWEATHERMAP_API_KEY"; // Replace with actual API key
  const city = "Prishtina"; // Default city, can be made dynamic
  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric&lang=en`;

  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error("Weather data not available");
    const data = await response.json();

    const weatherDiv = document.getElementById("weather-widget");
    if (weatherDiv) {
      weatherDiv.innerHTML = `
                <div style="background: rgba(255,255,255,0.9); padding: 16px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                    <h3 style="margin: 0 0 8px 0; color: #333;">Weather in ${data.name}</h3>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" alt="${data.weather[0].description}" style="width: 64px; height: 64px;">
                        <div>
                            <p style="margin: 0; font-size: 24px; font-weight: bold; color: #000;">${Math.round(data.main.temp)}°C</p>
                            <p style="margin: 0; color: #666; text-transform: capitalize;">${data.weather[0].description}</p>
                            <p style="margin: 0; color: #666;">Humidity: ${data.main.humidity}%</p>
                        </div>
                    </div>
                </div>
            `;
    }
  } catch (error) {
    console.error("Error loading weather:", error);
    const weatherDiv = document.getElementById("weather-widget");
    if (weatherDiv) {
      weatherDiv.innerHTML =
        '<p style="color: #666;">Weather data unavailable</p>';
    }
  }
}

document.addEventListener("DOMContentLoaded", loadWeather);
