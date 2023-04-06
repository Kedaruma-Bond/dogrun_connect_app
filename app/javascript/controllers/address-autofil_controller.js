import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'zipcode', 'address' ]
  static values = { apikey: String }

  async fetchAddress() {
    const zipcode = this.zipcodeTarget.value.replace(/-/g, '')

    if (zipcode.length === 7 && zipcode.match(/^\d+$/)) {
      const url = `https://apis.postcode-jp.com/api/v5/postcodes/${zipcode}?fields=allAddress`
      const response = await fetch(url, {
        headers: {
          "Content-Type": "application/json",
          "apikey": this.apikeyValue,
        }
      })

      const data = await response.json()
      console.log(data)
      
      if (data.length > 0) {
        this.addressTarget.value = data[0].allAddress
      } else (
        console.error("No data received from API.")
      )
    }
  }
}
