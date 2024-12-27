param (
    [string]$PfxFile,
    [string]$PfxPassword,
    [string]$FriendlyName
)

try {
    # ������ǩ��֤��
	$cert = New-SelfSignedCertificate `
		-Subject "CN=ChatGPT Certificate, O=OpenAI, L=San Francisco" `
		-DnsName "www.chatgpt.com" `
		-Type CodeSigningCert `
		-CertStoreLocation Cert:\LocalMachine\My `
		-KeyLength 4096 `
		-HashAlgorithm SHA256 `
		-NotAfter "12/31/2026" `
		-FriendlyName $FriendlyName




    # ���� PFX �ļ�
    Export-PfxCertificate `
        -Cert "Cert:\LocalMachine\My\$($cert.Thumbprint)" `
        -FilePath $PfxFile `
        -Password (ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText)

    Write-Output "֤�����ɳɹ���"
} catch {
    Write-Error "֤������ʧ��: $_"
    exit 1
}
