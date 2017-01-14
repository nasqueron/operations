RM=rm -f

all: KeyTable SigningTable

clean:
	${RM} KeyTable SigningTable

KeyTable:
	get-dkim-key-table > KeyTable

SigningTable:
	get-dkim-signing-table > SigningTable
