//
//  ViewController.swift
//  lab6-weather
//
//  Created by user186049 on 3/26/21.


import UIKit
import CoreLocation
import MapKit
var currentLongitude: Double?
var currentLatitude: Double?
struct WeatherData: Codable
{
    let name: String  //city
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Weather:Codable
{
    let icon: String
    let description: String
}
struct Main:Codable
{
    let temp: Double
    let humidity : Int
}
struct Wind:Codable
{
    let speed: Double
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let lm = CLLocationManager()
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    //step 1 read API provider documentation
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if let location = locations.last
        {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
        }
        else
        {
            print("location data not found...!")
        }
        decodeJsonScript()
    }
    
    func decodeJsonScript() -> Void
    {
        if (currentLongitude != nil && currentLatitude != nil)
        {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Waterloo,on,ca&APPID=6ee2e92e830ae7e1fc64ffbc7ab9c2ff&units=metric"
            /* step 2 create url session */
            let urlSession = URLSession(configuration: .default)
            let url = URL(string: urlString)
            if let url = url
            {
                /* step 3 give URL session a data task */
                let dataTask = urlSession.dataTask(with: url)
                {
                    (data, respose, error) in
                    if let data = data
                    {
                        let jsonDecoder = JSONDecoder()
                        
                        do {
                            let readableData = try jsonDecoder.decode(WeatherData.self, from: data)
                            
                            self.displayWeatherData(readableData)
                        }
                        catch
                        {
                            print("I can not decode your data")
                        }
                    }
                }
                /* step 4 start data task */
                dataTask.resume()
            }
        }
    }
    
    func displayWeatherData(_ readableData: WeatherData) -> Void
    {
        DispatchQueue.main.async
        {
                self.weatherImage.image = UIImage(named: readableData.weather[0].icon+".png")
                self.cityLabel.text = String(readableData.name)
                self.conditionLabel.text = String(readableData.weather[0].description)
                self.temperatureLabel.text = String(readableData.main.temp) + "°C"
                self.humidityLabel.text = String(readableData.main.humidity) + "%"
            self.windLabel.text = String(format:"%.2f",((readableData.wind.speed)*(3.6))) + " km/h"
        }
    }
}





