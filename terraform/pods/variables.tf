variable "remote_host" {
  description = "Public IP or DNS of the remote server"
  type        = string
  default     = "137.131.3.90"
}

variable "remote_user" {
  description = "SSH username (e.g., ubuntu, root)"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "Contents of the private SSH key"
  type        = string
  sensitive   = true
  default     = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAwKwqkvUFrDmBvgqUA/7V5NJhsFLNclRDmggvgkcslOrqGdwQ
7+Y7HArUXM3OIHMzabkrd7Zmo8aoAOMRu6Qz010d76RowX/BPFFgdVYDzroDYXDH
GdkVpGZt47G5gIpZl6RyUs59oQPuS7u1mBB3HFYqkwDB/yRL/OjVPu26gAWLRvP+
9FKxbws/L3KOL5RMlupr6hGXFE8R8Bh1yxeHTmYDp94eWQSfaAjMp1/yPMmRitII
+RJjic7HCqKk0k3aRil1YuxYis2FKDey9fBcKlF/dhKc26sr0a5Z5XUb2QINrdOD
/GZLRy/JAKRfuZckXfA5Y/1jye/6s4ElbaystwIDAQABAoIBAAvp2WFoMydDZbQE
NW4ge3CrAuKt4V7jZPazm4nDsDcDu4vzy+b5kR1vx1J3C1AoWhJ8d6VEVbO6HI30
JxbiKq40Fh4eSA1G7VeMdJlswyQs46P1HuqIk3UB5w5ANrHYXCfV7EJrMDYc5xwv
CXsonCTYEx6EhSUAmo49218JFhIaVNhD9z3ORgI4+nfNlccVnZf7IorcmTFzXXi0
92RFNZWehEgob/FlraY9s5JygKXckS+8x2PFygnZkCUOI9cVq8+YCZaOUxSfb6EW
t7VGnJc6vMg9bglSjw5Ni87+YusOTR6bxmgxtb/an4zo8I3DjgeQT49f4oHJrwm6
yJMUcqECgYEA5PvjaqNZXPUxMclWjt641koq6YIvgkLiAjbPaqd5v/3DfARNZpfY
0pnj9vQkxBRVF/QsinYn+TdL8HRrcFZwepP9e/Z26VqqUuJurkA/iC8kryZsUXhb
/7UkpxkNQ2U9xg0Hq0nlbe3+n4ZU//cWIV2rgXbKTKojplDD7M6l9ZECgYEA12eM
AmZmO1KZzauuWsp2YkHWEkXob/QH54/bpFHib67iIXdBnkOVx/eQQzZlSjnl+T4p
5dQPrbWHc0KTt/nM5GK67KVs+JKXoVctmnkxRKaLQeCejH5J8nbA8nbbP3s1E1N/
6TVkNWBpkkp/tu/Vp/tMYC1rPOwxxrQeLFpluccCgYA2DTd7fp+jj8VTCUHDa9OZ
0dwbTr3EM+GBwEpp1KqqpU41whY7N3DZFbZ4Ht1m453Kj7rL3GRHMcRdOD38QItA
hBp73ovnPZ2i/ww9WbElhmtUZO+As7aTv8CtKP62f/l6/KxoxILB1kIaie0alsrE
iYXog4/xVOAhbEMzbPxD4QKBgFbL+rbc3ET7O86MZ21eN+XP8ZrbYJX8F1NPvImy
FTQ7nBMwItjLEwfI0fDDcn0+Z1TPn8JkeQzeIP5ozW1M0ysUPY4t+oMPTtpMbqvY
OeoX0fVxtXGXUeTJxWXuTtp9ox1ugBRQ11hKyT+RlXT5n3ZY5KW8p4GdC1GuMppc
srDxAoGBAIh9c5sWaRwrcUI5Jjz1oIdjV3Cr8PBMGl4P7iD4YMNYQgWkf9sN2GYS
HRT2aH6k2eOq+rroeaLlu8b+4yRPnqZwvtdbRCov50jRVBF5pXjnH94LsNhzaSA1
CbTvosX8uxK6mqtLfbKjIMNCDSbDWEEC1M6gjLsiL9YAe0XQp0Kd
-----END RSA PRIVATE KEY-----
EOF
}