package clients

import grails.converters.JSON
import grails.plugins.rest.client.RestBuilder

class ApiClient {
    def rest = new RestBuilder(connectTimeout: 10000, readTimeout: 20000)

    def post(String url, Map form) {
        def response = rest.post(url) {
            body (form as JSON)
            header "Content-Type", "application/json"
        }
        response.json
    }
    
    def get(String url, Map params = [:]) {
        def response = rest.get(url) {
            accept("application/json")
        }
        response.json
    }
}