// MARK:- Task 000 - Poker
/**
 - Author:
    Dimitrijevic Luka
 - Date:
    19.12.2020 - 25.12.2020
 - Feedback:
    So Happy, So Proud, So Much Fun!
 */
/**
 - pick the best hand(s) from a list of poker hands
 - important: the joker is not part of poker
 - possible poker hands:
    - high card         [K♥ J♥ 8♣ 7♦ 4♠]
    - one pair           [4♥ 4♠ K♠ 10♦ 5♠]
    - two pair           [J♥ J♣ 4♣ 4♠ 9♥]
    - three of a kind [2♦ 2♠ 2♣ K♠ 6♥]
    - straight            [7♣ 6♠ 5♠ 4♥ 3♥]
    - flush                [J♥ 8♥ 4♥ 3♥ 2♥]
    - four kind         [Q♥ Q♥ Q♥ Q♥ J♥]
    - full house        [ 3♣ 3♠ 3♦ 6♣ 6♥]
    - straight flush   [2♥ 3♥ 4♥ 5♥ 6♥]
    - royal flush       [A♣ K♣ Q♣ J♣ 10♣]
 - one poker hand consists of 5 cards (2 in texas hold'em + 5 on the table)
 - the program should deal **n** random poker hands on every game start (upto a maximum of 8 hands) per the maximum player amount i.e. 8
 - evaluate the winner
 - note: **No** duplicate cards are allowed! A deck consists of 52 unique cards, no jokers, no additional decks
 - note: "poker" language is used throughout the program, most important terminology is written here for overview purposes
                    - flop ... the round after the first bets and the very beginning of texas hold'em where 3 cards are laid face-up
                    - turn ... the round after the second bidding and after the flop where one card is laid face-up
                    - river ... the final round before the showdown where again only one card is laid face-up and bets can again take place
                    - showdown ... the reveal of players hands and the declaration of a winner
 */

import Foundation
// MARK:- Declarations

enum GameType : String
{
    case Poker = "Poker"
    case Texas = "Texas Hold'em"
}

enum Chips : Int
{
    case white = 1
    case red   = 5
    case blue  = 10
    case green = 25
    case black = 100
}

// TODO:- Struct
enum TableBlind : Int
{
    case big   = 100000     // 2xsmall = 10K
    case small = 100
}

enum Phase : String
{
    case preFlop  = "Pre-Flop"
    case flop     = "Flop"
    case turn     = "Turn"
    case river    = "River"
    case showdown = "Showdown"
}

enum Suit : String
{
    case spade   = "♠️"
    case diamond = "♦️"
    case club    = "♣️"
    case heart   = "♥️"
    case UNKNOWN = "🃏"
}

enum Rank : Int
{
    case ace     = 0
    case king    = 1
    case queen   = 2
    case jack    = 3
    case ten     = 4
    case nine    = 5
    case eight   = 6
    case seven   = 7
    case six     = 8
    case five    = 9
    case four    = 10
    case three   = 11
    case two     = 12
    case UNKNOWN = 13
    
    //: necessary parser for non ascii numbered value comparisons
    func parse(value: Rank) -> String
    {
        switch value
        {
            case .ace:      return "A"
            case .king:     return "K"
            case .queen:    return "Q"
            case .jack:     return "J"
            case .ten:      return "10"
            case .nine:     return "9"
            case .eight:    return "8"
            case .seven:    return "7"
            case .six:      return "6"
            case .five:     return "5"
            case .four:     return "4"
            case .three:    return "3"
            case .two:      return "2"
            case .UNKNOWN:  return "-1"
        }
    }
}

enum HandRank : Int
{
    case RoyalFlush    = 9  // 10| J | Q | K | A - straight flush from 10 to A
    case StraightFlush = 8  // 2 | 3 | 4 | 5 | 6 - straight of the same suit
    case FourKind      = 7  // 6 | 6 | 6 | 6 | K - four of the same value
    case FullHouse     = 6  // K | K | K | 7 | 7 - three same values and a pair
    case Flush         = 5  // K | Q | 9 | 8 | 2 - all same suit
    case Straight      = 4  // 3 | 4 | 5 | 6 | 7 - increasing value sequence A2 or KA
    case ThreeKind     = 3  // J | J | J | 8 | 5 - three same value cards
    case TwoPair       = 2  // A | 4 | 4 | 6 | 6 - two times two same value cards
    case OnePair       = 1  // Q | 7 | 3 | 8 | 8 - two same value cards
    case HighCard      = 0  // 10| 4 | 7 | K | 2 - lowest 2 highest A
    case UNKNOWN       = -1
}

class Card
{
    private let rank : Rank
    private let suit : Suit
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    public func getSuit() -> Suit
    {
        return suit
    }
    
    public func getRank() -> Rank
    {
        return rank
    }
    
    public func print() {
        let output = "\(suit.rawValue + rank.parse(value: rank))"
        Swift.print(output, terminator: " ")
    }
}

class Hand
{
    private var cards : [Card]
    
    init() {
        self.cards = [Card]()
    }
    init(cards: [Card])
    {
        self.cards = cards
    }
    
    public func newCard(card: Card)
    {
        cards.append(card)
    }
    
    public func getCards() -> [Card]
    {
        return cards
    }
    
    public func print()
    {
        cards.forEach{$0.print()}
    }
    
    public func print(playerID: String, cards: [Card])
    {
        Swift.print(playerID + ":", terminator: " ")
        cards.forEach{ $0.print() }
        Swift.print("\n")
    }
}

class Player
{
    private let name : String
    private let hand : Hand
    private var buyInAmount : Int
    private var chips : [Chips : Int]
    
    init(name: String) {
        self.name               = name
        self.hand               = Hand()
        self.chips              = [:]
        self.chips[Chips.white] = 0
        self.chips[Chips.red]   = 0
        self.chips[Chips.blue]  = 0
        self.chips[Chips.green] = 0
        self.chips[Chips.black] = 0
        self.buyInAmount = TableBlind.small.rawValue
    }
    
    init(name: String, hand: Hand, money: Int) {
        self.name          = name
        self.hand          = hand
        self.chips         = [:]
        self.chips[.white] = 0
        self.chips[.red]   = 0
        self.chips[.blue]  = 0
        self.chips[.green] = 0
        self.chips[.black] = 0
        self.buyInAmount   = money
    }
    
    public func getID() -> String
    {
        return name
    }
    
    public func getHand() -> Hand
    {
        return hand
    }
    
    public func addMoney(money: Int)
    {
        buyInAmount += money
    }
    
    public func convertMoney(amount: inout Int) -> [Chips: Int]
    {
        while (amount > 0)
        {
            if amount < 10
            {
                if amount != 5
                {
                    chips[.white]! += 1
                    amount /= Chips.white.rawValue
                }
                else
                {
                    chips[.red]! += 1
                    amount /= Chips.red.rawValue
                }
            }
            else
            {
                switch amount {
                    case Chips.white.rawValue:
                        chips[.white]! += 1
                        amount /= Chips.white.rawValue
                    case Chips.red.rawValue:
                        chips[.red]!   += 1
                        amount /= Chips.red.rawValue
                    case Chips.blue.rawValue:
                        chips[.blue]!  += 1
                        amount /= Chips.blue.rawValue
                    case Chips.green.rawValue:
                        chips[.green]! += 1
                        amount /= Chips.green.rawValue
                    case Chips.black.rawValue:
                        chips[.black]! += 1
                        amount /= Chips.black.rawValue
                    default:
                        print("🤪 🃏🃏🃏🃏 🤪")
                }
            }
        }
        return chips
    }
    
    public func buyIn() -> Int
    {
        return buyInAmount
    }
}

class Table
{
    private let game    : GameType
    private var players : [Player]
    private let dealer  : Dealer
    private let blind   : TableBlind
    private var pot     : Int
    
    private var communityCards : [Card]
    
    init(game: GameType, dealer: Dealer, blind: TableBlind, lhp: Player, rhp: Player) {
        self.game    = game
        self.dealer  = dealer
        self.blind   = blind
        self.pot     = 0
        self.players = [Player]()
        self.players.append(lhp)
        self.players.append(rhp)
        self.pot     += players[0].buyIn()
        self.pot     += players[1].buyIn()
        self.communityCards = [Card]()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        if game == .Poker { print("========== POKER MATCH \(String(describing: format.string(from: Date()))) ==========")}
        if game == .Texas { print("========== TEXAS HOLD'EM MATCH \(String(describing: format.string(from: Date()))) ==========")}
    }
    
    public func join(player: Player, money: Int = 0)
    {
        if (money != 0)
        {
            player.addMoney(money: money)
        }
        
        if players.count < 8
        {
            if (player.buyIn() >= blind.rawValue)
            {
                self.pot += player.buyIn()
                players.append(player)
            }
            else
            {
                print("You need more chips for this buy in.\nBlind is \(blind.rawValue), you need \(blind.rawValue-player.buyIn())")
            }
        }
        else
        {
            print("A maximum of 8 players is allowed. Try the slots ^^")
        }
    }
    
    public func startGame()
    {
        dealer.dealCards(game: game, players: players, cards: &communityCards)
        
        if game == .Texas
        {
            print("========== Community Cards ==========")
            for c in communityCards
            {
                c.print()
            }
            print("\n")
        }
        
        print("========== Pot Amount ==========")
        print("∑ = \(self.pot)\t\t\(self.blind) blind")
    }
    
    public func getPlayers() -> [Player]
    {
        return players
    }
    
    public func whosPlaying()
    {
        print("Who's Playing?")
        self.getPlayers().forEach{ $0.getHand().print(playerID: $0.getID(), cards: $0.getHand().getCards()) }
    }
    
    public func potWinnings()
    {
        print("========== Pot Amount ==========")
        print("∑ = \(self.pot)\t\t\(self.blind) blind")
    }
    
    public func displayWinner(debug: Bool=false)
    {
        print("========== Cards On The Table ==========")
        for p in players
        {
            print("\(p.getID()) has ", terminator:" ")
            p.getHand().print()
            print(terminator:"\n")
        }
        
        var handsList : [HandRank] = []
        
        if game == .Poker
        {
            handsList = dealer.evaluate(players: players, debug: debug)
        }
        else if game == .Texas
        {
            handsList = dealer.evaluate(players: players, cards: communityCards, debug: debug)
        }
        
        var winner : (Int, HandRank) = (-1,.UNKNOWN)
        
        for i in 0..<handsList.count
        {
            if (winner.1.rawValue < handsList[i].rawValue)
            {
                winner = (i, handsList[i])
            }
            // check if hand ranks are the same between players
            else if (winner.1.rawValue == handsList[i].rawValue)
            {
                // check high card hand accross players
                let player = dealer.HighCard(players: players, debug: true)
                
                for j in 0..<players.count
                {
                    if (players[j].getID() == player.0.getID())
                    {
                        winner = (i % players.count,handsList[i])
                        break
                    }
                }
            }
        }
        
        print("Winning Player \(players[winner.0].getID())'s Hand", terminator:" ")
        players[winner.0].getHand().print()
        print(terminator:"\n")
        print("Winning Hand \(winner.1)")
        print(terminator:"\n")
    }
}

class Dealer
{
    private final let ranks : [Rank] = [.ace, .king, .queen, .jack, .ten, .nine, .eight, .seven, .six, .five, .four, .three, .two]
    
    private final let deck : [Suit:[Card]] = [.club : [Card(rank: .ace,   suit: .club),
                                                       Card(rank: .king,  suit: .club),
                                                       Card(rank: .queen, suit: .club),
                                                       Card(rank: .jack,  suit: .club),
                                                       Card(rank: .ten,   suit: .club),
                                                       Card(rank: .nine,  suit: .club),
                                                       Card(rank: .eight, suit: .club),
                                                       Card(rank: .seven, suit: .club),
                                                       Card(rank: .six,   suit: .club),
                                                       Card(rank: .five,  suit: .club),
                                                       Card(rank: .four,  suit: .club),
                                                       Card(rank: .three, suit: .club),
                                                       Card(rank: .two,   suit: .club)
                                                      ],
                                           .diamond : [Card(rank: .ace,   suit: .diamond),
                                                       Card(rank: .king,  suit: .diamond),
                                                       Card(rank: .queen, suit: .diamond),
                                                       Card(rank: .jack,  suit: .diamond),
                                                       Card(rank: .ten,   suit: .diamond),
                                                       Card(rank: .nine,  suit: .diamond),
                                                       Card(rank: .eight, suit: .diamond),
                                                       Card(rank: .seven, suit: .diamond),
                                                       Card(rank: .six,   suit: .diamond),
                                                       Card(rank: .five,  suit: .diamond),
                                                       Card(rank: .four,  suit: .diamond),
                                                       Card(rank: .three, suit: .diamond),
                                                       Card(rank: .two,   suit: .diamond)
                                                      ],
                                             .spade : [Card(rank: .ace,   suit: .spade),
                                                       Card(rank: .king,  suit: .spade),
                                                       Card(rank: .queen, suit: .spade),
                                                       Card(rank: .jack,  suit: .spade),
                                                       Card(rank: .ten,   suit: .spade),
                                                       Card(rank: .nine,  suit: .spade),
                                                       Card(rank: .eight, suit: .spade),
                                                       Card(rank: .seven, suit: .spade),
                                                       Card(rank: .six,   suit: .spade),
                                                       Card(rank: .five,  suit: .spade),
                                                       Card(rank: .four,  suit: .spade),
                                                       Card(rank: .three, suit: .spade),
                                                       Card(rank: .two,   suit: .spade)
                                                      ],
                                             .heart : [Card(rank: .ace,   suit: .heart),
                                                       Card(rank: .king,  suit: .heart),
                                                       Card(rank: .queen, suit: .heart),
                                                       Card(rank: .jack,  suit: .heart),
                                                       Card(rank: .ten,   suit: .heart),
                                                       Card(rank: .nine,  suit: .heart),
                                                       Card(rank: .eight, suit: .heart),
                                                       Card(rank: .seven, suit: .heart),
                                                       Card(rank: .six,   suit: .heart),
                                                       Card(rank: .five,  suit: .heart),
                                                       Card(rank: .four,  suit: .heart),
                                                       Card(rank: .three, suit: .heart),
                                                       Card(rank: .two,   suit: .heart)
                                                      ]
    ]
    
    private var usedCardsStack : [Card] = [Card]()
}

// poker evaluation extension
extension Dealer
{
    public func evaluate(players: [Player], debug: Bool=false) -> [HandRank]
    {
        func isDone(result: Bool, container: [String: Bool]) -> Bool
        {
            if result
            {
                if (debug)
                {
                    for (k,v) in container
                    {
                        if v { print("[check] \(k)") }
                    }
                }
                return true
            }
            return false
        }
        
        func checkHand(player: Player) -> HandRank
        {
            if debug {print(player.getID() + "'s Hand ======================================================================================================")}
            var decision : [String: Bool] = [:]
            
            var result = FullHouse(hand: player.getHand().getCards(), debug: debug)
            decision["Full House\t\t(contains three cards of one rank and two cards of another rank)"     ] = (result)
            if isDone(result:result, container: decision) { return .FullHouse }
            
            result = RoyalFlush(hand: player.getHand().getCards(), debug: debug)
            decision["Royal Flush\t\t(contains five cards of sequential rank, all of the same suit, from 10 to A)" ] = (result)
            if isDone(result:result, container: decision) { return .RoyalFlush }
            
            result = StraightFlush(hand: player.getHand().getCards(), debug: debug)
            decision["Straight Flush\t(contains five cards of sequential rank, all of the same suit, from 2 to 6)" ] = (result)
            if isDone(result:result, container: decision) { return .StraightFlush }
            
            result = Flush(hand: player.getHand().getCards(), debug: debug)
            decision["Flush\t\t\t(contains five cards all of the same suit, not all of sequential rank)"          ] = (result)
            if isDone(result:result, container: decision) { return .Flush }
            
            result = ThreeKind(hand: player.getHand().getCards(), debug: debug)
            decision["Three Of A Kind\t(contains three cards of one rank and two cards of two other ranks)"] = (result)
            if isDone(result:result, container: decision) { return .ThreeKind }
            
            result = TwoPair(hand: player.getHand().getCards(), debug: debug)
            decision["Two Pair\t\t(contains two cards of one rank, two cards of another rank and one card of a third rank)"       ] = (result)
            if isDone(result:result, container: decision) { return .TwoPair }
            
            result = OnePair(hand: player.getHand().getCards(), debug: debug)
            decision["One Pair\t\t(contains two cards of one rank and three cards of three other ranks)"       ] = (result)
            if isDone(result:result, container: decision) { return .OnePair }
            
            result = FourKind(hand: player.getHand().getCards(), debug: debug)
            decision["Four Of A Kind\t(contains four cards of one rank and one card of another rank)" ] = (result)
            if isDone(result:result, container: decision) { return .FourKind }
            
            result = Straight(hand: player.getHand().getCards(), debug: debug)
            decision["Straight\t\t(contains five cards of sequential rank, not all of the same suit)"       ] = (result)
            if isDone(result:result, container: decision) { return .Straight }
            
            return .UNKNOWN
        }
        
        var handRank : [HandRank] = []
        
        for p in players
        {
            if debug   { p.getHand().print() }
            handRank.append(checkHand(player: p))
        }
        
        return handRank
    }
}

// deal card extension
extension Dealer
{
    public func dealCards(game: GameType, players: [Player], cards: inout [Card])
    {
        if game == .Poker
        {
            // deal 5 cards each, 1 by 1 !
            for _ in 1...5
            {
                for p in players
                {
                    
                    // FIXME:- [OPTIMISE] Remove cards from deck after drawing a card
                    var card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                    while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                    {
                        card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                    }
                    
                    usedCardsStack.append(card)
                    p.getHand().newCard(card: card)
                }
            }
        }
        else if game == .Texas
        {
            for _ in 1...2
            {
                // deal 2 cards each
                for p in players
                {
                    var card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                    while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                    {
                        card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                    }
                    usedCardsStack.append(card)
                    p.getHand().newCard(card: card)
                }
            }
            
            var ph : Phase = .preFlop
            while ph != .showdown
            {
                switch ph {
                    case .preFlop:
                        print("========== 1st Betting Round ==========")
                        ph = .flop
                    case .flop:
                        // burn one card
                        var card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        }
                        usedCardsStack.append(card)
                        
                        var i = 0
                        while (i < 3)
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                            while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                            {
                                card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                            }
                            usedCardsStack.append(card)
                            cards.append(card)
                            i += 1
                        }
                        ph = .turn
                    case .turn:
                        // burn one card
                        var card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        }
                        usedCardsStack.append(card)
                        
                        card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        }
                        usedCardsStack.append(card)
                        cards.append(card)
                        ph = .river
                    case.river:
                        // burn one card
                        var card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        }
                        usedCardsStack.append(card)
                        
                        card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        while (usedCardsStack.contains(where: {$0.getSuit().rawValue == card.getSuit().rawValue && $0.getRank().rawValue == card.getRank().rawValue}))
                        {
                            card = deck.randomElement()?.value.randomElement() ?? Card(rank: .UNKNOWN, suit: .UNKNOWN)
                        }
                        usedCardsStack.append(card)
                        cards.append(card)
                        ph = .showdown
                    case .showdown:
                        print("========== Showdown ==========")
                }
            }
        }
    }
}

// hand evaluation functions
extension Dealer
{
    public func HighCard(players: [Player], debug: Bool=false) -> (Player, Bool)
    {
        func forward(first: Card, second: Card) -> Bool
        {
            return first.getRank().rawValue > second.getRank().rawValue
        }
        
        var highestRankingHand = t1.getPlayers()[0].getHand().getCards().sorted(by: forward)
        var highestRank : Rank = Rank.UNKNOWN
        var isHighCard  : Player = players[0]
        
        // only cards in player's hand count!
        for i in 1..<players.count
        {
            let p = players[i]
            
            // sort and check each high card for the winner
            let cards : [Card] = p.getHand().getCards().sorted(by: forward)
            
            for c in cards
            {
                if (c.getRank().rawValue > highestRank.rawValue)
                {
                    highestRank = c.getRank()
                    print("rank check: \(highestRank)")
                }
            }
            
            for i in 0..<cards.count
            {
                if (highestRankingHand[i].getRank().rawValue > cards[i].getRank().rawValue)
                {
                    if (highestRank.rawValue < highestRankingHand[i].getRank().rawValue)
                    {
                        highestRank = highestRankingHand[i].getRank()
                        isHighCard = p
                    }
                }
                else
                {
                    if (highestRank.rawValue < cards[i].getRank().rawValue)
                    {
                        highestRank = cards[i].getRank()
                        isHighCard = p
                    }
                }
            }
            
            highestRankingHand = cards
        }
        
        return (isHighCard, true)
    }
    
    private func OnePair(hand: [Card], debug: Bool=false) -> Bool
    {
        var rankCount : [Int: Int] = [:]
        hand.forEach{ rankCount[ranks[$0.getRank().rawValue].rawValue, default: 0]+=1 }
        
        if rankCount.values.contains(2)
        {
            return true
        }
        return false
    }
    
    private func TwoPair(hand: [Card], debug: Bool=false) -> Bool
    {
        var pairCount = 0
        
        for c in 0..<3
        {
            for i in c+1..<hand.count
            {
                if debug
                {
                    hand[c].print()
                    hand[i].print()
                    print("---")
                }
                
                if hand[c].getRank().rawValue == hand[i].getRank().rawValue
                {
                    pairCount += 1
                }
            }
        }
        
        if hand[3].getRank().rawValue == hand[4].getRank().rawValue
        {
            pairCount += 1
        }
        
        return (pairCount == 2) ? true : false
    }
    
    private func ThreeKind(hand: [Card], debug: Bool=false) -> Bool
    {
        var rankCount : [Int: Int] = [:]
        hand.forEach{ rankCount[ranks[$0.getRank().rawValue].rawValue, default: 0]+=1 }
        if (rankCount.values.contains(3))
        {
            return true
        }
        return false
    }
    
    private func Straight(hand: [Card], debug: Bool=false) -> Bool
    {
        let sortedHand = hand.sorted(){ranks[$0.getRank().rawValue].rawValue < ranks[$1.getRank().rawValue].rawValue}
        
        if (debug) {
            for c in sortedHand
            {
                c.print()
            }
            print(terminator:"\n")
            print("count: \(sortedHand.count)")
        }
        
        var prev = sortedHand.first
        var areAscRank = false
        for c in 1..<sortedHand.count
        {
            if (debug)
            {
                print("prev \(prev?.getRank())")
                print("sorted \(sortedHand[c].getRank())")
                print("\((ranks[prev?.getRank().rawValue ?? Rank.UNKNOWN.rawValue].rawValue + 1)) == \(ranks[sortedHand[c].getRank().rawValue].rawValue)")
            }
            
            // get the value of the current element in the array and compare it to the value of the next one
            if ((ranks[prev?.getRank().rawValue ?? Rank.UNKNOWN.rawValue].rawValue + 1) == ranks[sortedHand[c].getRank().rawValue].rawValue)
            {
                areAscRank = true
                prev = sortedHand[c]
            }
            else
            {
                return false
            }
        }
    
        return areAscRank
    }
    
    private func Flush(hand: [Card], debug: Bool=false) -> Bool
    {
        return hand.dropFirst().allSatisfy({ $0.getSuit() == hand.first?.getSuit() })
    }
    
    private func FullHouse(hand: [Card], debug: Bool=false) -> Bool
    {
        return self.ThreeKind(hand: hand) && self.OnePair(hand: hand)
    }
    
    private func FourKind(hand: [Card], debug: Bool=false) -> Bool
    {
        var rankCount : [Int: Int] = [:]
        hand.forEach{ rankCount[ranks[$0.getRank().rawValue].rawValue, default: 0]+=1 }
        if (rankCount.values.contains(4))
        {
            return true
        }
        return false
    }
    
    private func StraightFlush(hand: [Card], debug: Bool=false) -> Bool
    {
        if self.Flush(hand: hand)
        {
            return self.Straight(hand: hand)
        }
        return false
    }
    
    private func RoyalFlush(hand: [Card], debug: Bool=false) -> Bool
    {
        if self.StraightFlush(hand: hand)
        {
            hand.sorted(){ranks[$0.getRank().rawValue].rawValue < ranks[$1.getRank().rawValue].rawValue}
            return (
            (hand[0].getRank() == Rank.ace)   &&
            (hand[1].getRank() == Rank.king)  &&
            (hand[2].getRank() == Rank.queen) &&
            (hand[3].getRank() == Rank.jack)  &&
            (hand[4].getRank() == Rank.ten))
        }
        return false
    }
}

// texas hold'em evaluation extension
extension Dealer
{
/**
    //: use the player's two cards in conjunction with the 5 on the table
    //: find the best hand for each player and see which one won
    - note: one or both cards from the player's hand must be used!
 */
    public func evaluate(players: [Player], cards: [Card], debug: Bool=false) -> [HandRank]
    {
        func isDone(result: Bool, container: [String: Bool]) -> Bool
        {
            if result
            {
                if (debug)
                {
                    for (k,v) in container
                    {
                        if v { print("[check] \(k)") }
                    }
                }
                return true
            }
            return false
        }
        
        func checkHand(hand: [Card]) -> HandRank
        {
            var decision : [String: Bool] = [:]
            
            var result = FullHouse(hand: hand, debug: debug)
            decision["Full House\t\t(contains three cards of one rank and two cards of another rank)"     ] = (result)
            if isDone(result:result, container: decision) { return .FullHouse }
            
            result = RoyalFlush(hand: hand, debug: debug)
            decision["Royal Flush\t\t(contains five cards of sequential rank, all of the same suit, from 10 to A)" ] = (result)
            if isDone(result:result, container: decision) { return .RoyalFlush }
            
            result = StraightFlush(hand: hand, debug: debug)
            decision["Straight Flush\t(contains five cards of sequential rank, all of the same suit, from 2 to 6)" ] = (result)
            if isDone(result:result, container: decision) { return .StraightFlush }
            
            result = Flush(hand: hand, debug: debug)
            decision["Flush\t\t\t(contains five cards all of the same suit, not all of sequential rank)"          ] = (result)
            if isDone(result:result, container: decision) { return .Flush }
            
            result = ThreeKind(hand: hand, debug: debug)
            decision["Three Of A Kind\t(contains three cards of one rank and two cards of two other ranks)"] = (result)
            if isDone(result:result, container: decision) { return .ThreeKind }
            
            result = TwoPair(hand: hand, debug: debug)
            decision["Two Pair\t\t(contains two cards of one rank, two cards of another rank and one card of a third rank)"       ] = (result)
            if isDone(result:result, container: decision) { return .TwoPair }
            
            result = OnePair(hand: hand, debug: debug)
            decision["One Pair\t\t(contains two cards of one rank and three cards of three other ranks)"       ] = (result)
            if isDone(result:result, container: decision) { return .OnePair }
            
            result = FourKind(hand: hand, debug: debug)
            decision["Four Of A Kind\t(contains four cards of one rank and one card of another rank)" ] = (result)
            if isDone(result:result, container: decision) { return .FourKind }
            
            result = Straight(hand: hand, debug: debug)
            decision["Straight\t\t(contains five cards of sequential rank, not all of the same suit)"       ] = (result)
            if isDone(result:result, container: decision) { return .Straight }
            
            return .UNKNOWN
        }
        
        func scaleHand(best: inout HandRank, current: HandRank) -> Bool
        {
            if current.rawValue > best.rawValue
            {
                best = current
                return true
            }
            return false
        }
        
        var bestHand         : ([Card],HandRank) = ([Card](),HandRank.UNKNOWN)
        
        var cardCombinations : [[Card]]          = []                   // holds all possible hands for each player individually
        var bestRank         : (Int, HandRank)   = (0, HandRank.UNKNOWN)// saves the best rank and points to the position of its hand in cardCombinations
        var playerHand       : [(Int, HandRank)] = []                   // holds information about each players best hand
        
        var i : Int = 0
        
        for p in players
        {
            //: see possible combinations with one from player and sequentially interchange with ones on the table upto a maximum of 5 in one hand
            //: left card combinations
            bestHand.0 = [p.getHand().getCards()[0], cards[0], cards[1], cards[2], cards[3]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[0], cards[1], cards[2], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[0], cards[0], cards[1], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[0], cards[0], cards[1], cards[2], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[0], cards[0], cards[2], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestRank.0 = i
            bestRank.1 = bestHand.1
            if (debug) { print("best hand rank = \(bestHand.1)") }
            
            playerHand.append(bestRank)
            bestHand = ([Card](),HandRank.UNKNOWN)

            cardCombinations = [[Card]()]
            
            //: right card combinations
            bestHand.0 = [p.getHand().getCards()[1], cards[0], cards[1], cards[2], cards[3]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[1], cards[1], cards[2], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[1], cards[0], cards[1], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[1], cards[0], cards[1], cards[2], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestHand.0 = [p.getHand().getCards()[1], cards[0], cards[2], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestRank.0 = i
            bestRank.1 = bestHand.1
            if (debug) { print("best hand rank = \(bestHand.1)") }
            
            playerHand.append(bestRank)
            bestHand = ([Card](),HandRank.UNKNOWN)
            cardCombinations = [[Card]()]
            
            //: then try the same approach with two
            //: save only the **best** one for each player
            //: first run
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[1], cards[2]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[1], cards[2], cards[3]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[2], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[1], cards[3]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[1], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestRank.0 = i
            bestRank.1 = bestHand.1
            if (debug) { print("best hand rank = \(bestHand.1)") }
            
            playerHand.append(bestRank)
            bestHand = ([Card](),HandRank.UNKNOWN)
            cardCombinations = [[Card]()]
            
            //: second run
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[1], cards[2], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[1], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[2], cards[3]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[2], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            bestHand.0 = [p.getHand().getCards()[0], p.getHand().getCards()[1], cards[0], cards[3], cards[4]]
            if (scaleHand(best: &bestHand.1, current: checkHand(hand: bestHand.0))) { cardCombinations.append(bestHand.0) }
            
            bestRank.0 = i
            bestRank.1 = bestHand.1
            if (debug) { print("best hand rank = \(bestHand.1)") }
            
            playerHand.append(bestRank)
            
            i += 1 // increment player index
        }
        
        /**
         playerHand contains the best hands for each player (upto a maximum of 8)
         iterate through all hands associated with one player and evaluate the best one
         each player has 4 tuples, because of the 4 card combinations
         */
        
        if (debug)
        {
            for h in playerHand
            {
                print("playerHand = \(h.0), \(h.1)")
            }
        }
    
        // highest ranking hand overall
        var handRank : [HandRank] = []
        
        var highestHand : HandRank = .UNKNOWN
        
        for h in playerHand
        {
            if (highestHand.rawValue < h.1.rawValue)
            {
                highestHand = h.1
            }
            else if (highestHand.rawValue == h.1.rawValue)
            {
                let player = HighCard(players: players)
                if (players[h.0].getID() == player.0.getID())
                {
                    highestHand = h.1
                }
            }
            handRank.append(highestHand)
        }
        
        /*
        for p in 0..<playerHand.count
        {
            let i = 0;
            
            if (playerHand[i].1.rawValue > playerHand[i+1].1.rawValue)              // 1st > 2nd
            {
                if (playerHand[i].1.rawValue > playerHand[i+2].1.rawValue)          // 1st > 3rd
                {
                    if (playerHand[i].1.rawValue > playerHand[i+3].1.rawValue)      // 1st > 4th
                    {
                        handRank.append(playerHand[i].1)
                    }
                }
            }
            // have the same hand rank
            else if (players[p].getHand().getCards()[playerHand[i].0].getRank().rawValue == players[p].getHand().getCards()[playerHand[i+1].0].getRank().rawValue)
            {
                let player = HighCard(players: players)
                if (player.0.getID() == players[p].getID())
                {
                    handRank.append(playerHand[i].1)
                }
            }
            else                                                                    // 2nd > 3rd
            {
                if (playerHand[i+1].1.rawValue > playerHand[i+2].1.rawValue)
                {
                    if (playerHand[i+1].1.rawValue > playerHand[i+3].1.rawValue)    // 2nd > 4th
                    {
                        handRank.append(playerHand[i+1].1)
                    }
                    else                                                            // 4th > 2nd
                    {
                        if (playerHand[i+3].1.rawValue > playerHand[i+2].1.rawValue)// 4th > 3rd
                        {
                            handRank.append(playerHand[i+3].1)
                        }
                        else
                        {
                            handRank.append(playerHand[i+2].1)
                        }
                    }
                }
                else
                {
                    if (playerHand[i+2].1.rawValue > playerHand[i+3].1.rawValue)    // 3rd > 4th
                    {
                        handRank.append(playerHand[i+2].1)
                    }
                    else                                                            // 4th > 3rd
                    {
                        handRank.append(playerHand[i+3].1)
                    }
                }
            }
        }
         */
        
         if (debug)
         {
             for h in handRank
             {
                 print("rank \(h)")
             }
         }
         return handRank
    }
}

// MARK:- Calls, Test, Output

let hands = [
                Hand(cards: [
                    Card(rank: .ace,   suit: .spade),
                    Card(rank: .king,  suit: .diamond),
                    Card(rank: .four,  suit: .heart),
                    Card(rank: .ace,   suit: .club),
                    Card(rank: .six,   suit: .spade)
                ]),
                Hand(cards: [
                    Card(rank: .king,  suit: .spade),
                    Card(rank: .king,  suit: .heart),
                    Card(rank: .king,  suit: .club),
                    Card(rank: .two,   suit: .club),
                    Card(rank: .three, suit: .club)
                ]),
                Hand(cards: [
                    Card(rank: .ace,   suit: .heart),
                    Card(rank: .king,  suit: .heart),
                    Card(rank: .queen, suit: .heart),
                    Card(rank: .jack,  suit: .heart),
                    Card(rank: .ten,   suit: .heart)
                ]),
                Hand(cards: [
                    Card(rank: .ace,   suit: .spade),
                    Card(rank: .ace,   suit: .heart),
                    Card(rank: .ace,   suit: .club),
                    Card(rank: .jack,  suit: .spade),
                    Card(rank: .jack,  suit: .club)
                ]),
                Hand(cards: [
                    Card(rank: .two,   suit: .diamond),
                    Card(rank: .two,   suit: .spade),
                    Card(rank: .six,   suit: .club),
                    Card(rank: .ten,   suit: .heart),
                    Card(rank: .king,  suit: .spade)
                ]),
                Hand(cards: [
                    Card(rank: .ace,   suit: .diamond),
                    Card(rank: .king,  suit: .diamond),
                    Card(rank: .queen, suit: .diamond),
                    Card(rank: .jack,  suit: .spade),
                    Card(rank: .ten,   suit: .diamond)
                ]),
                Hand(cards: [
                    Card(rank: .five,  suit: .club),
                    Card(rank: .five,  suit: .spade),
                    Card(rank: .three, suit: .club),
                    Card(rank: .three, suit: .diamond),
                    Card(rank: .jack,  suit: .spade)
                ])
            ]
let texasHands = [
                Hand(cards: [
                    Card(rank: .queen,   suit: .diamond),
                    Card(rank: .eight,  suit: .heart)
                ]),
                Hand(cards: [
                    Card(rank: .five,   suit: .heart),
                    Card(rank: .nine,  suit: .spade)
                ]),
                Hand(cards: [
                    Card(rank: .ace,   suit: .diamond),
                    Card(rank: .queen,  suit: .club)
                ]),
    ]

let p1 = Player(name: "Player 1", hand: hands[0], money: TableBlind.small.rawValue)
let p2 = Player(name: "Player 2", hand: hands[1], money: TableBlind.small.rawValue)
let p3 = Player(name: "Player 3", hand: hands[2], money: TableBlind.small.rawValue)
let p4 = Player(name: "Player 4", hand: hands[3], money: TableBlind.small.rawValue)
let p5 = Player(name: "Player 5", hand: hands[4], money: TableBlind.small.rawValue)
let p6 = Player(name: "Player 6", hand: hands[5], money: TableBlind.small.rawValue)
let p7 = Player(name: "Player 7", hand: hands[6], money: TableBlind.small.rawValue)
let d1  = Dealer()
let t1 = Table(game: .Poker, dealer: d1, blind: TableBlind.small, lhp: p1, rhp: p2)
t1.join(player: p3)
t1.join(player: p4)
t1.join(player: p5)
t1.join(player: p6)
t1.join(player: p7)
//t1.whosPlaying()

t1.displayWinner(debug: false)

print("======================================================================================================")

let p8 = Player(name: "Adam")
let p9 = Player(name: "Eve")
let p10 = Player(name: "God")
let d2  = Dealer()
let t2 = Table(game: .Poker, dealer: d2, blind: TableBlind.big, lhp: p8, rhp: p9)
t2.join(player: p10, money: TableBlind.big.rawValue)
t2.whosPlaying()
t2.startGame()
t2.displayWinner()

print("======================================================================================================")

let pA = Player(name: "Cain")
let pB = Player(name: "Abel")
let pC = Player(name: "Moses")
let d3  = Dealer()
let t3 = Table(game: .Texas, dealer: d3, blind: TableBlind.small, lhp: pA, rhp: pB)
t3.join(player: pC)
t3.whosPlaying()
t3.startGame()
t3.displayWinner()

print(".done")
