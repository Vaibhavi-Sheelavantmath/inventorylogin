
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract InventoryLog {
    // Address that deployed the contract
    address public owner;

    // Each item has a name and a quantity
    struct Item {
        string name;
        uint256 quantity;
        bool exists;
    }

    // Map an item ID (number) to the item details
    mapping(uint256 => Item) private items;

    // Keep a simple count of how many item IDs have been used
    uint256 public itemCount;

    // Simple events to track actions
    event ItemAdded(uint256 indexed itemId, string name, uint256 quantity);
    event ItemUpdated(uint256 indexed itemId, uint256 oldQuantity, uint256 newQuantity);

    // Constructor without any input parameters
    constructor() {
        owner = msg.sender;
    }

    // Restrict some functions to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    // Add a new item to the inventory
    function addItem(string calldata name, uint256 quantity) external onlyOwner {
        require(bytes(name).length > 0, "Name required");
        require(quantity > 0, "Quantity must be > 0");

        itemCount += 1;
        items[itemCount] = Item({
            name: name,
            quantity: quantity,
            exists: true
        });

        emit ItemAdded(itemCount, name, quantity);
    }

    // Update quantity of an existing item
    function updateQuantity(uint256 itemId, uint256 newQuantity) external onlyOwner {
        require(items[itemId].exists, "Item does not exist");
        require(newQuantity >= 0, "Invalid quantity"); // >= 0 is always true for uint, but kept for clarity

        uint256 oldQty = items[itemId].quantity;
        items[itemId].quantity = newQuantity;

        emit ItemUpdated(itemId, oldQty, newQuantity);
    }

    // Read details of an item
    function getItem(uint256 itemId) external view returns (string memory name, uint256 quantity) {
        require(items[itemId].exists, "Item does not exist");
        Item storage item = items[itemId];
        return (item.name, item.quantity);
    }
}
