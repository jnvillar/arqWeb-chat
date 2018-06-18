package clients

import grails.plugins.rest.client.RestBuilder
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap


class ApiClient {
    def rest = new RestBuilder(connectTimeout: 10000, readTimeout: 20000)

    def post(String url, Map params) {
        MultiValueMap form = new LinkedMultiValueMap<>()

        params.each {
            form.add(it.key, it.value)
        }

        def response = rest.post(url) {
            accept("application/json")
            contentType("application/x-www-form-urlencoded")
            body(form)
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
