param (
    [string]$PfxFile,
    [string]$PfxPassword,
    [string]$FriendlyName
)

try {
    # 生成自签名证书
	$cert = New-SelfSignedCertificate `
		-Subject "CN=ChatGPT Certificate, O=OpenAI, L=San Francisco" `
		-DnsName "www.chatgpt.com" `
		-Type CodeSigningCert `
		-CertStoreLocation Cert:\LocalMachine\My `
		-KeyLength 4096 `
		-HashAlgorithm SHA256 `
		-NotAfter "12/31/2026" `
		-FriendlyName $FriendlyName




    # 导出 PFX 文件
    Export-PfxCertificate `
        -Cert "Cert:\LocalMachine\My\$($cert.Thumbprint)" `
        -FilePath $PfxFile `
        -Password (ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText)

    Write-Output "证书生成成功。"
} catch {
    Write-Error "证书生成失败: $_"
    exit 1
}
