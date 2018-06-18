package clients

import grails.plugins.rest.client.RestBuilder


class ApiClient {
    def rest = new RestBuilder(connectTimeout: 10000, readTimeout: 20000)

    def post(String url, Map params) {
        println "post to ${url}"

        def response = rest.post(url) {
            json{ params }
        }

        println "post response"
        println response.json
        response.json
    }
    
    def get(String url, Map params = [:]) {
        println "get to ${url}"

        def response = rest.get(url) {
            accept("application/json")
        }

        println "get response"
        println response.json

        response.json
    }
}
