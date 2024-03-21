// Specifies the license under which this contract is released; MIT in this case
// SPDX-License-Identifier: MIT

// Specifies the Solidity compiler version this contract is compatible with
pragma solidity ^0.8.20;

// Imports the ERC721 standard implementation from OpenZeppelin, a library of secure and community-vetted smart contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Defines a new contract named PokeDIO, inheriting from OpenZeppelin's ERC721 implementation
contract PokeDIO is ERC721 {
    // Defines a struct named Pokemon, representing each unique Pokemon with a name, level, and image URL
    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    // Declares an array to store all pokemons created in this contract
    Pokemon [] public pokemons;

    // Stores the address of the game owner (the user who deployed the contract)
    address public gameOwner;

    // The constructor function, setting the token name to "PokeDIO" and symbol to "PKD"
    // It also initializes the gameOwner variable with the address of the contract deployer
    constructor () ERC721 ("PokeDIO","PKD") {
        gameOwner = msg.sender;
    }

    // Defines a modifier to restrict certain functions to only the owner of a specific Pokemon
    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Only the owner can battle with this Pokemon");
        _; // Continues execution of the modified function
    }

    // Defines a function that allows Pokemon battles between two Pokemons, with their IDs as parameters
    // This function can only be called by the owner of the attacking Pokemon
    function battle (uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon){
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        // Determines the outcome of the battle based on Pokemon levels
        // The winner gains 2 levels, and the loser gains 1 level
        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }     

    // Allows the game owner to create a new Pokemon and assign it to a player
    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        // Ensures that only the game owner can create new Pokemons
        require(msg.sender == gameOwner, "Only the game owner can create new Pokemons");
        uint id = pokemons.length; // The new Pokemon's ID is its index in the 'pokemons' array
        pokemons.push(Pokemon(_name, 1, _img)); // Adds the new Pokemon to the array
        _safeMint(_to, id); // Mints a new ERC721 token for the Pokemon and assigns it to the player
    }

}
