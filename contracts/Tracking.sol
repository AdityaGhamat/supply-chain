// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tracking {
    enum ShipmentStatus {PENDING, IN_TRANSIT, DELIVERED}

    struct Shipments {
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliveryTime;
        uint256 distance;
        uint256 price;
        ShipmentStatus status;
        bool isPaid;
    }

    mapping(address => Shipments[]) public shipments;
    uint256 public shipmentCount;

    struct TypeShipment {
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliveryTime;
        uint256 distance;
        uint256 price;
        ShipmentStatus status;
        bool isPaid;
    }

    TypeShipment[] public typeShipment;

    event ShipmentCreated(
        address indexed sender,
        address indexed receiver,
        uint256 pickupTime,
        uint256 distance,
        uint256 price
    );
    event ShipmentInTransit(
        address indexed sender,
        address indexed receiver,
        uint256 pickupTime
    );
    event ShipmentDelivered(
        address indexed sender,
        address indexed receiver,
        uint256 deliveryTime
    );
    event ShipmentPaid(
        address indexed sender,
        address indexed receiver,
        uint256 amount
    );

    constructor() {
        shipmentCount = 0;
    }

    function createShipment(
        address _receiver,
        uint256 _pickupTime,
        uint256 _distance,
        uint256 _price
    ) public payable {
        require(msg.value == _price, "Payment amount must match actual price.");

        Shipments memory newShipment = Shipments({
            sender: msg.sender,
            receiver: _receiver,
            pickupTime: _pickupTime,
            deliveryTime: 0,
            distance: _distance,
            price: _price,
            status: ShipmentStatus.PENDING,
            isPaid: false
        });

        shipments[msg.sender].push(newShipment);
        shipmentCount++;

        typeShipment.push(TypeShipment({
            sender: msg.sender,
            receiver: _receiver,
            pickupTime: _pickupTime,
            deliveryTime: 0,
            distance: _distance,
            price: _price,
            status: ShipmentStatus.PENDING,
            isPaid: true
        }));

        emit ShipmentCreated(msg.sender, _receiver, _pickupTime, _distance, _price);
    }

    function startShipment(
        address _sender,
        address _receiver,
        uint256 _index
    ) public {
        require(_index < shipments[_sender].length, "Invalid shipment index");

        Shipments storage shipmentEntry = shipments[_sender][_index];
        TypeShipment storage typeShipmentEntry = typeShipment[_index];

        require(
            shipmentEntry.receiver == _receiver,
            "Invalid receiver"
        );
        require(
            shipmentEntry.status == ShipmentStatus.PENDING,
            "Shipment already in transit"
        );

        shipmentEntry.status = ShipmentStatus.IN_TRANSIT;
        typeShipmentEntry.status = ShipmentStatus.IN_TRANSIT;

        emit ShipmentInTransit(
            _sender,
            _receiver,
            shipmentEntry.pickupTime
        );
    }

    function completeShipment(
        address _sender,
        address _receiver,
        uint256 _index
    ) public {
        Shipments storage shipmentEntry = shipments[_sender][_index];
        TypeShipment storage typeShipmentEntry = typeShipment[_index];

        require(
            shipmentEntry.receiver == _receiver,
            "Invalid receiver"
        );
        require(
            shipmentEntry.status == ShipmentStatus.IN_TRANSIT,
            "Shipment not in transit"
        );
        require(
            !shipmentEntry.isPaid,
            "Shipment is alredy paid" 
        );
        shipmentEntry.status = ShipmentStatus.DELIVERED;
        typeShipmentEntry.status = ShipmentStatus.DELIVERED;
        shipmentEntry.deliveryTime = block.timestamp;
        typeShipmentEntry.deliveryTime = block.timestamp;

        uint256 amount = shipmentEntry.price;

        payable(shipmentEntry.sender).transfer(amount);

        shipmentEntry.isPaid = true;
        typeShipmentEntry.isPaid = true;

        emit ShipmentDelivered(
            _sender,
            _receiver,
            shipmentEntry.deliveryTime
        );
        emit ShipmentPaid(
            _sender,
            _receiver,
            amount
        );
    }

    function getShipment(
        address _sender,
        uint256 _index
    ) public view returns(
        address,
        address,
        uint256,
        uint256,
        uint256,
        uint256,
        ShipmentStatus,
        bool
    ){
        Shipments memory shipment = shipments[_sender][_index]; 
        return (
            shipment.sender,
            shipment.receiver,
            shipment.pickupTime,
            shipment.deliveryTime,
            shipment.distance,
            shipment.price,
            shipment.status,
            shipment.isPaid
        );
    }
    function getShipmentcount(
        address _sender
    ) public view returns(
        uint256
    )
    {
        return shipments[_sender].length; 
    }
    function getAllTransactions()
    public view 
    returns (
        TypeShipment[] memory
    )
    {
        return typeShipment;
    }
}
