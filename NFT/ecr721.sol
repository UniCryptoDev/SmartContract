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

// Dichiarazione del contratto UniCryptoToken.
contract UniCryptoToken is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    // Contatore per tracciare il prossimo ID di token da mintare.
    uint256 private _nextTokenId;

    // Costruttore del contratto
    constructor(address initialOwner)
        ERC721("UniCryptoToken", "UCK") // Imposta nome e simbolo del token.
        Ownable(initialOwner) // Imposta l'owner iniziale del contratto.
    {}

    // Funzione per mintare in modo sicuro un nuovo NFT.
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
}
