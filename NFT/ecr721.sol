// SPDX-License-Identifier: MIT
// Il contratto è rilasciato sotto licenza MIT.
pragma solidity ^0.8.22; 
// Specifica la versione del compilatore di Solidity.

import {ERC721} from "@openzeppelin/contracts@5.1.0/token/ERC721/ERC721.sol";
// Importa il contratto base per creare e gestire NFT (ERC-721 standard).
import {ERC721Enumerable} from "@openzeppelin/contracts@5.1.0/token/ERC721/extensions/ERC721Enumerable.sol";
// Aggiunge funzionalità per enumerare i token.
import {ERC721URIStorage} from "@openzeppelin/contracts@5.1.0/token/ERC721/extensions/ERC721URIStorage.sol";
// Consente di associare una URI ai token per memorizzare i metadati.
import {Ownable} from "@openzeppelin/contracts@5.1.0/access/Ownable.sol";
// Permette la gestione del contratto tramite un proprietario (owner).

// Dichiarazione del contratto UniCryptoToken con le dovute implementazioni.
contract UniCryptoToken is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    // Contatore per tracciare il prossimo ID di token da mintare.
    uint256 private _nextTokenId; // intero senza segno di 256bit [0,2^(256) - 1]

    // Costruttore del contratto
    // (wallet) address: valore esadecimale di 20 byte
    constructor(address initialOwner)
        ERC721("UniCryptoToken", "UCK") // Imposta nome e simbolo del token.
        Ownable(initialOwner) // Imposta l'owner iniziale del contratto.
    {}

    // Funzione per mintare in modo sicuro un nuovo NFT.
    // Il gas è l'unità di misura che rappresenta la quantità di lavoro computazionale necessario per eseguire un operazione
    // Gas Fee = gas used * gas price
    // la parola chiave memory indica un parametro temporaneo che viene archiviato SOLO durante l'esecuzione del metodo
    function safeMint(address to, string memory uri) public onlyOwner {
        // Verifica che solo il proprietario del contratto possa chiamare questa funzione.
        uint256 tokenId = _nextTokenId++; // Incrementa il contatore e assegna l'ID al nuovo token.
        _safeMint(to, tokenId); // Esegue il minting e trasferisce il token al destinatario.
        _setTokenURI(tokenId, uri); // Associa una URI al token per memorizzare i metadati.
    }

    // Funzione interna per aggiornare i dati del token dopo un trasferimento.
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth); // Esegue la logica di aggiornamento definita nei contratti base.
    }

    // Funzione interna per aumentare il bilancio di un indirizzo.
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value); // Chiama la logica combinata dei contratti base.
    }

    // Restituisce l'URI associata a un token specifico.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId); // Usa l'implementazione di ERC721URIStorage.
    }

    // Verifica se il contratto supporta una specifica interfaccia.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId); // Controlla la compatibilità con le interfacce ERC-721.
    }
    
    /* 
    * Modificatori di Accesso:
    * view indica che il metodo non modifica lo stato del contratto ma può solo leggerlo
    * payable indica che il metodo può ricevere Ether
    * external indica che il metodo può essere chiamata solo dall’esterno del contratto
    * internal indica che il metodo può essere chiamata solo all’interno del contratto stesso e dai contratti derivati (protected di Java)
    * private indica che il metodo può essere chiamata solo all’interno del contratto in cui è dichiarata
    * public indica una variabile/metodo accessibile sia internamente che esternamente
    * override indica che il metodo sovrascrive una funzione con lo stesso nome e firma in un contratto base
    * virtual indica che il metodo può essere sovrascritta in un contratto derivato
    * pure indica che il metodo né legge né modifica lo stato del contratto => esegue calcoli/logica NON dipendente dal contratto senza impiegare gas
    */
}
