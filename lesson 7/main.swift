//
//  main.swift
//  lesson 7
//
//  Created by Сергей Беляков on 25.03.2021.
//

import Foundation

// MARK: - Do/Catch

struct Movie {
    let name: String
}

struct Ticket {
    let price: Int
    var availableSeats: Int
    let movie: Movie
}

enum TicketSellError: Error {
    case invalidSelection
    case outOfAvailableSeats
    case insufficientFunds(moneyNeeded: Int)
    case invalidEnter(isAvailable: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidSelection:
            return "Такого фильма сейчас нет"
        case .outOfAvailableSeats:
            return "Недостаточно свободных мест"
        case .insufficientFunds(moneyNeeded: let moneyNeeded):
            return "Недостаточно денег, добавьте \(moneyNeeded)"
        case .invalidEnter(isAvailable: let isAvailable):
            return "Ошибка ввода. Вы можете купить от 1 до \(isAvailable) билетов"
        }
    }
}

class Cinema {
    var tickets = [
        "Spider-Man": Ticket (price: 10, availableSeats: 50, movie: Movie(name: "Spider-Man")),
        "Batman": Ticket(price: 12, availableSeats: 10, movie: Movie(name: "Batman")),
        "Matrix": Ticket(price: 25, availableSeats: 8, movie: Movie(name: "Matrix"))
    ]
    
    func sell (movie name: String, ticketsNeeded: Int) -> (movie: Movie?, numberOfTickets: Int?, error: TicketSellError?) {
        
        guard let movieName = tickets[name] else {
            return (movie: nil, numberOfTickets: nil, error: TicketSellError.invalidSelection)
        }
        guard money >= movieName.price * ticketsNeeded else {
            return (movie: nil, numberOfTickets: nil, error: TicketSellError.insufficientFunds(moneyNeeded: movieName.price * ticketsNeeded - money))
        }
        guard movieName.availableSeats >= ticketsNeeded else {
            return (movie: nil, numberOfTickets: nil, error: TicketSellError.outOfAvailableSeats)
        }
        guard ticketsNeeded > 0 else {
            return (movie: nil, numberOfTickets: nil, error: TicketSellError.invalidEnter(isAvailable: movieName.availableSeats))
        }
        
        money -= movieName.price * ticketsNeeded
        var newTicket = movieName
        newTicket.availableSeats -= ticketsNeeded
        tickets[name] = newTicket
        return (movie: newTicket.movie, numberOfTickets: ticketsNeeded, error: nil)
    }
}

var money = 200
let ticketOffice = Cinema()
let sell1 = ticketOffice.sell(movie: "Spider-Man", ticketsNeeded: 5)
let sell2 = ticketOffice.sell(movie: "Batman", ticketsNeeded: 12)
let sell3 = ticketOffice.sell(movie: "Matrix", ticketsNeeded: 8)
let sell4 = ticketOffice.sell(movie: "Spider-Man", ticketsNeeded: -1)
let sell5 = ticketOffice.sell(movie: "Star Wars", ticketsNeeded: 1)

if let movie = sell1.movie {
    print("Вы купили: \(sell1.numberOfTickets!) билет(ов) \(movie.name) ")
} else if let error = sell1.error {
    print("Произошла ошибка: \(error.localizedDescription)")
}

if let movie = sell2.movie {
    print("Вы купили: \(sell2.numberOfTickets!) билет(ов) \(movie.name) ")
} else if let error = sell2.error {
    print("Произошла ошибка: \(error.localizedDescription)")
}

if let movie = sell3.movie {
    print("Вы купили: \(sell3.numberOfTickets!) билет(ов) \(movie.name) ")
} else if let error = sell3.error {
    print("Произошла ошибка: \(error.localizedDescription)")
}

if let movie = sell4.movie {
    print("Вы купили: \(sell4.numberOfTickets!) билет(ов) \(movie.name) ")
} else if let error = sell4.error {
    print("Произошла ошибка: \(error.localizedDescription)")
}

if let movie = sell5.movie {
    print("Вы купили: \(sell5.numberOfTickets!) билет(ов) \(movie.name) ")
} else if let error = sell5.error {
    print("Произошла ошибка: \(error.localizedDescription)")
}

// MARK: - Throws

print("______________________________\n")

extension Cinema {
    func throwsSell (movie name: String, ticketsNeeded: Int) throws -> (movie: Movie, numberOfTickets: Int) {
        
        guard let movieName = tickets[name] else {
            throw TicketSellError.invalidSelection
        }
        guard money >= movieName.price * ticketsNeeded else {
            throw TicketSellError.insufficientFunds(moneyNeeded: movieName.price * ticketsNeeded - money)
        }
        guard movieName.availableSeats >= ticketsNeeded else {
            throw TicketSellError.outOfAvailableSeats
        }
        guard ticketsNeeded > 0 else {
            throw TicketSellError.invalidEnter(isAvailable: movieName.availableSeats)
        }
        
        money -= movieName.price * ticketsNeeded
        var newTicket = movieName
        newTicket.availableSeats -= ticketsNeeded
        tickets[name] = newTicket
        return (movie: newTicket.movie, numberOfTickets: ticketsNeeded)
        
    }
}

money = 600

do {
    let sell6 = try ticketOffice.throwsSell(movie: "Spider-Man", ticketsNeeded: 36)
    print("Вы купили: \(sell6.numberOfTickets) билет(ов) \(sell6.movie.name) ")
} catch TicketSellError.insufficientFunds(let moneyNeeded) {
    print ("Недостаточно денег, добавьте \(moneyNeeded)")
    
} catch TicketSellError.invalidEnter(let isAvailable) {
    print("Ошибка ввода. Вы можете купить от 1 до \(isAvailable) билетов")
    
} catch TicketSellError.invalidSelection {
    print("Такого фильма сейчас нет")
    
} catch TicketSellError.outOfAvailableSeats {
    print("Недостаточно свободных мест")
}

do {
    let sell7 = try ticketOffice.throwsSell(movie: "Batman 8", ticketsNeeded: 5)
    print("Вы купили: \(sell7.numberOfTickets) билет(ов) \(sell7.movie.name) ")
} catch TicketSellError.insufficientFunds(let moneyNeeded) {
    print ("Недостаточно денег, добавьте \(moneyNeeded)")
    
} catch TicketSellError.invalidEnter(let isAvailable) {
    print("Ошибка ввода. Вы можете купить от 1 до \(isAvailable) билетов")
    
} catch TicketSellError.invalidSelection {
    print("Такого фильма сейчас нет")
    
} catch TicketSellError.outOfAvailableSeats {
    print("Недостаточно свободных мест")
}

do {
    let sell8 = try ticketOffice.throwsSell(movie: "Matrix", ticketsNeeded: 20)
    print("Вы купили: \(sell8.numberOfTickets) билет(ов) \(sell8.movie.name) ")
} catch TicketSellError.insufficientFunds(let moneyNeeded) {
    print ("Недостаточно денег, добавьте \(moneyNeeded)")
    
} catch TicketSellError.invalidEnter(let isAvailable) {
    print("Ошибка ввода. Вы можете купить от 1 до \(isAvailable) билетов")
    
} catch TicketSellError.invalidSelection {
    print("Такого фильма сейчас нет")
    
} catch TicketSellError.outOfAvailableSeats {
    print("Недостаточно свободных мест")
}

do {
    let sell9 = try ticketOffice.throwsSell(movie: "Spider-Man", ticketsNeeded: 10 )
    print("Вы купили: \(sell9.numberOfTickets) билет(ов) \(sell9.movie.name) ")
} catch TicketSellError.insufficientFunds(let moneyNeeded) {
    print ("Недостаточно денег, добавьте \(moneyNeeded)")
    
} catch TicketSellError.invalidEnter(let isAvailable) {
    print("Ошибка ввода. Вы можете купить от 1 до \(isAvailable) билетов")
    
} catch TicketSellError.invalidSelection {
    print("Такого фильма сейчас нет")
    
} catch TicketSellError.outOfAvailableSeats {
    print("Недостаточно свободных мест")
}
