import Headers "Headers";

import T "Types";

module {

    public class Request(_url : Text, _method : Text) {
        public let url = _url;
        public let method = _method;
        public let headers = Headers();
        public var body = Blob.fromArray([]);

    };

    public fromRawRequest(rawRequest : T.HttpRequest) : Request {
        let { url; method; headers; body } = rawRequest;

        let request = Request(url, method);
        request.body := body;

        for ((field, value) in headers.vals()) {
            request.headers.add(field, value);
        };
    };
};
