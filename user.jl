struct User
    userID::String
    message::Array
    friends::Array
end

function setMessage(message, user)
    push!(user.message, message)
end

function setFrind(friend, user)
    push!(user.friends, friend)
end

user = User("123", [], [])

