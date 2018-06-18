package clients

import grails.plugins.rest.client.RestBuilder
import org.grails.web.json.JSONObject

class ApiClient {
    def rest = new RestBuilder(connectTimeout: 10000, readTimeout: 20000)

    def post(String url, Map params) {

        JSONObject json = new JSONObject()

        params.each { json.put(it.key, it.value) }

        def response = rest.post(url) {
            accept("application/json")
            contentType("application/json")
            body(json)
        }

        println "post response"
        println response.json
        response.json
    }
    
    def get(String url, Map params = [:]) {
        def response = rest.get(url) {
            accept("application/json")
        }

        println "get response"
        println response.json

        response.json
    }
}
