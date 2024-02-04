pragma solidity ^0.8.0;

contract Ordonnances {
    
    // **Structure:**
    struct Ordonnance {
        uint256 id;   // Unique identifier for the ordonnance
        string RPPS;  // Patient's identification number (RPPS)
        TypeContrat contenu;  // Type of ordonnance (COURT, LONG, or STUPEFIANT)
        uint256 timestamp;  // Timestamp when the ordonnance was created
        bytes32 token;  // Unique token associated with the ordonnance
    }    
    
    // Id of the ordonnance
    uint256 private ordonnanceCount;

    // **Mapping:**
    // A mapping to store all ordonnances
    mapping(uint256 => Ordonnance) public ordonnances;

    // **Enumeration:**
    // Represents the type of ordonnance
    enum TypeContrat { COURT, LONG, STUPEFIANT }

    // **Events:**
    // Emitted when an ordonnance is created
    event OrdonnanceCreated(
        uint256 id,  // Identifier of the created ordonnance
        string RPPS,  // Patient's RPPS
        TypeContrat typecontrat,  // Type of the created ordonnance
        uint256 timestamp,  // Timestamp when the ordonnance was created
        bytes32 token  // Unique token associated with the ordonnance
    );
    
    // Emitted when an ordonnance is deleted
    event OrdonnanceDeleted(uint256 id);


    // **Constructor:**
    // Initializes the ordonnance count
    constructor() {
        ordonnanceCount = 0;
    }
    
    // **Function:**

    // Creates a new ordonnance
    function creerOrdonnance(string memory _RPPS, uint _valeurType) public {
        // Increments the ordonnance count
        ordonnanceCount++;

        // Validates the type value
        require(_valeurType > 0 && _valeurType < 4, "Invalid type value");

        // Converts the type value to the corresponding enum type
        TypeContrat contrat = TypeContrat(_valeurType);

        // Generates a unique token for the ordonnance
        bytes32 token = keccak256(abi.encodePacked(ordonnanceCount, _RPPS, block.timestamp));

        // Adds the new ordonnance to the mapping
        ordonnances[ordonnanceCount] = Ordonnance(ordonnanceCount, _RPPS, contrat, block.timestamp, token);

        // Sends the token to the patient's account
        // (This code would need to be implemented using a secure mechanism)

        // Emits the "OrdonnanceCreated" event
        emit OrdonnanceCreated(ordonnanceCount, _RPPS, contrat, block.timestamp, token);
    }

    // **Function:**
    // Checks if an ordonnance's date is still valid
    function verifierDateOrdonnance(uint256 _id) public view returns (bool) {
        Ordonnance memory ordonnance = ordonnances[_id];
        uint limit;

        // Define the limit in days with the type of contrat 
        if( ordonnance.contenu == TypeContrat.COURT){
            limit = 90;
        }else if(ordonnance.contenu == TypeContrat.LONG) {
            limit = 365;
        }
        else if(ordonnance.contenu == TypeContrat.STUPEFIANT) {
            limit = 3;
        }

        // Calculates the remaining validity period based on the ordonnance type
        uint256 diff = block.timestamp - ordonnance.timestamp;
        uint256 diffInDays = diff / (60 * 60 * 24);

        // Checks if the ordonnance is still valid
        return (diffInDays <= limit);
    }

    // **Function:**
    // Returns the ordonnance with the specified ID
    function obtenirOrdonnance(uint256 _id) public view returns (uint256, string memory, TypeContrat, uint256) {
        Ordonnance memory ordonnance = ordonnances[_id];
        return (ordonnance.id, ordonnance.RPPS, ordonnance.contenu, ordonnance.timestamp);
    }

    // **Function:**
    // Returns true if the token in input is the same as the ordonnance token
    function verifierToken(uint256 _id, bytes32 _token) public view returns (bool) {
        Ordonnance memory ordonnance = ordonnances[_id];
        return (ordonnance.token == _token);
    }

    
    // **Function:**
    // Delete the ordonnance
    function supprimerOrdonnance(uint256 _id) public {
        delete ordonnances[_id];
        emit OrdonnanceDeleted(_id);
    }

}
