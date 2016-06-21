# Using Terraform to create an Azure VM with WinRM enabled over SSL

See [here](https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials) for details on how to obtain credentials, then update [credentials.tf](credentials.tf).

You'll also need the Azure cross-platform CLI installed and authenticated (run the command `azure login` to do so).

You can use the following Go code to verify connectivity:

```go
package main

import (
	"fmt"
	"github.com/masterzen/winrm"
	"io"
	"net/http"
	"os"
	"time"

	ntlmssp "github.com/Azure/go-ntlmssp"
)

// If using non-SSL for WinRM, you'd need to run the following on the VM:
//
//	winrm set winrm/config/service '@{AllowUnencrypted="true"}'

const (
	host     = "af-tf-vm1.eastus.cloudapp.azure.com"
	port     = 5986
	username = `tintoy`
	password = `asswordPolicy!`
	timeout  = 10 * time.Second
)

func main() {
	params := winrm.DefaultParameters
	params.TransportDecorator = func(transport *http.Transport) http.RoundTripper {
		return &ntlmssp.Negotiator{
			RoundTripper: transport,
		}
	}

	fmt.Println(">> Configuring connection...")
	endpoint := winrm.NewEndpoint(host, port, true, true, nil, nil, nil, timeout)
	client, err := winrm.NewClientWithParameters(endpoint, username, password, params)
	if err != nil {
		panic(err)
	}

	fmt.Printf(">> Connecting to '%s:%d'...\n", host, port)
	shell, err := client.CreateShell()
	if err != nil {
		panic(err)
	}

	fmt.Println(">> Connected. Running cmd.exe...")
	var cmd *winrm.Command
	cmd, err = shell.Execute("cmd.exe")
	if err != nil {
		panic(err)
	}

	go io.Copy(cmd.Stdin, os.Stdin)
	go io.Copy(os.Stdout, cmd.Stdout)
	go io.Copy(os.Stderr, cmd.Stderr)

	fmt.Println(">> cmd.exe running; waiting for termination...")
	cmd.Wait()
	shell.Close()

	fmt.Println("Done.")
}
```