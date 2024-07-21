// SPDX-License-Identifier: MIT


pragma solidity ^0.8;

contract Management{

    struct Event{
        address organizer;
        string eventName;
        uint date;
        uint price;
        uint ticket;
        uint remainingTicket;
    }
    mapping (uint=>Event) public events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextid;

    function createEvent(string memory _name,uint _date,uint _price,uint _ticket) external {
       
       require(_date>block.timestamp, "You will be create only future events");
       require(_ticket>0,"You can organize event only if you create more than 0 ticket");
       events[nextid]=Event(msg.sender,_name,_date,_price,_ticket,_ticket);
       nextid++;

    }

    function buyTicket(uint quantity, uint id) external  payable {

        require(events[id].date!=0,"This Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity), "Amount is not enough");
        require(quantity<=_event.remainingTicket, "Tickets are not available");
        _event.remainingTicket-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(address to, uint transferedQuantity, uint id)external{

        require(events[id].date!=0,"This Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=transferedQuantity, "You have not enough ticket");
        tickets[msg.sender][id]-=transferedQuantity;
        tickets[to][id]+=transferedQuantity;
    }
}