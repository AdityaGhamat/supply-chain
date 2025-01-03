//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tracking {
    enum ShipmentStatus {PENDING,IN_TRANSIT,DELIVERED}
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
    mapping (address => Shipments[]) public shipments;

    uint256 public shipmentCount;
   
   struct TypeShipment{
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

   event ShipmentCreated(address indexed sender,address indexed receiver,
   uint256 pickupTime,uint256 distance,uint256 price);
   event ShipmentInTransit(address indexed sender,address indexed receiver,uint256 pickupTime);
   event ShipmentDelivered(address indexed sender,address indexed receiver,uint256 deliveryTime);
   event ShipmentPaid(address indexed sender,address indexed receiver,uint256 amount);

   constructor() {
    shipmentCount = 0;
   }

   function createShipment(address _receiver,uint256 _pickupTime,
    uint256 _distance,uint256 _price) public payable{
    require(msg.value == _price,"Payment amount must match actual price.");
    Shipments memory shipment = Shipments(msg.sender,_receiver,_pickupTime,0,_distance,_price,
    ShipmentStatus.PENDING,false);
    shipments[msg.sender].push(shipment);
    shipmentCount++;

    typeShipment.push(TypeShipment(msg.sender,_receiver,_pickupTime,0,_distance,_price,
    ShipmentStatus.PENDING,false));

    emit ShipmentCreated(msg.sender,_receiver,_pickupTime,_distance,_price);
   }

//    function startShipment(address _sender,address _receiver,uint256 _index) public {
//     Shipments storage shipments  = shipments[_sender][_index];
//    }
}