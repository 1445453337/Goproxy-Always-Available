package vps

import (
	"encoding/base64"
	"net"
	"net/http"
	"net/url"

	"github.com/phuslu/http2"
)

var (
	reqWriteExcludeHeader = map[string]bool{
		"Vary":                true,
		"Via":                 true,
		"X-Forwarded-For":     true,
		"Proxy-Authorization": true,
		"Proxy-Connection":    true,
		"Upgrade":             true,
		"X-Chrome-Variations": true,
		"Connection":          true,
		"Cache-Control":       true,
	}
)

type FetchServer struct {
	URL       *url.URL
	Username  string
	Password  string
	SSLVerify bool
	Transport *http2.Transport
}

func (f *FetchServer) RoundTrip(req *http.Request) (resp *http.Response, err error) {
	for key, shouldDelete := range reqWriteExcludeHeader {
		if shouldDelete && req.Header.Get(key) != "" {
			req.Header.Del(key)
		}
	}

	req.Header.Set("Proxy-Authorization", base64.StdEncoding.EncodeToString([]byte(f.Username+":"+f.Password)))

	resp, err = f.Transport.RoundTrip(req)
	if err != nil {
		return nil, err
	}

	return resp, nil
}

func (f *FetchServer) Connect(req *http.Request) (conn net.Conn, err error) {
	return nil, nil
}
