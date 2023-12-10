// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

/**
 * User opens a conversation by going to the profile
 * Receiver can accept or decline the conversation
 * If accepted, the conversation is open
 * If declined, the conversation is closed and the tokens are returned to the sender
 * If the conversation is open, the sender can close the conversation
 */

contract DolaCommmunicate {
    IERC20 public token;

    event NewConversation(
        string indexed topicId,
        bytes messageId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    event AcceptConversation(
        string indexed topicId,
        bytes messageId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    event DeclineConversation(
        string indexed topicId,
        bytes messageId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    event CloseConversation(
        string indexed topicId,
        bytes messageId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    enum ConversationStatus {
        Open,
        Accepted,
        Declined,
        Closed
    }

    struct Conversation {
        string topicId;
        bytes messageId;
        address from;
        address to;
        uint256 fee;
        ConversationStatus status;
    }

    // using messageId for the identifier

    mapping(string => Conversation) public conversations;

    address public owner;

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender;
    }

    /// @notice Open conversation with the given address
    /// @param _messageId The XMTP message ID
    /// @param _to The address of the receiver
    /// @param _amount The amount of USDC to be sent
    function openConversation(
        bytes calldata _messageId,
        string memory _topic,
        address _to,
        uint256 _amount
    ) external {
        // transfer tokens to the contract
        token.transferFrom(msg.sender, address(this), _amount);

        // store conversation
        conversations[_topic] = Conversation({
            topicId: _topic,
            messageId: _messageId,
            from: msg.sender,
            to: _to,
            fee: _amount,
            status: ConversationStatus.Open
        });

        // emit event
        emit NewConversation(_topic, _messageId, msg.sender, _to, _amount);
    }

    function acceptConversation(string memory _topic) external {
        Conversation memory conversationCache = conversations[_topic];

        // store conversation
        conversations[_topic] = Conversation({
            topicId: _topic,
            messageId: conversationCache.messageId,
            from: conversationCache.from,
            to: conversationCache.to,
            fee: conversationCache.fee,
            status: ConversationStatus.Accepted
        });

        // emit event
        emit AcceptConversation(
            _topic,
            conversationCache.messageId,
            conversationCache.from,
            conversationCache.to,
            conversationCache.fee
        );
    }

    function declineConversation(string memory _topic) external {
        Conversation memory conversationCache = conversations[_topic];

        // store conversation
        conversations[_topic] = Conversation({
            topicId: _topic,
            messageId: conversationCache.messageId,
            from: conversationCache.from,
            to: conversationCache.to,
            fee: conversationCache.fee,
            status: ConversationStatus.Declined
        });

        // transfer tokens back to the sender
        token.transfer(conversationCache.from, conversationCache.fee);

        // emit event
        emit DeclineConversation(
            _topic,
            conversationCache.messageId,
            conversationCache.from,
            conversationCache.to,
            conversationCache.fee
        );
    }

    function closeConversation(string memory _topic) external {
        Conversation memory conversationCache = conversations[_topic];

        // store conversation
        conversations[_topic] = Conversation({
            topicId: _topic,
            messageId: conversationCache.messageId,
            from: conversationCache.from,
            to: conversationCache.to,
            fee: conversationCache.fee,
            status: ConversationStatus.Closed
        });

        // transfer tokens back to the sender
        token.transfer(conversationCache.to, conversationCache.fee);

        // emit event
        emit CloseConversation(
            _topic,
            conversationCache.messageId,
            conversationCache.from,
            conversationCache.to,
            conversationCache.fee
        );
    }

    function emergencyWithdraw() external {
        require(msg.sender == owner, "Not owner");
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
