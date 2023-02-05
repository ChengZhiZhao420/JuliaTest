using Gtk
include("user.jl")

b = GtkBuilder(filename="./view/testview.glade")
win = b["window2"]
registerBu = b["register"]
userList = b["userList"]
ls = b["userGroup"]
add = b["add"]
messageB = b["message"]
inboxB = b["seeMessage"]
selection = GAccessor.selection(userList)
userArray = User[]

signal_connect(inboxB, "button-press-event") do widget, event 
    if hasselection(selection)
        for i in eachindex(userArray) 
            if userArray[i].userID == ls[selected(selection),1]
                sendFriendPost(userArray[i])
                println(userArray[i])
            end
        end
        
    end
end

signal_connect(messageB, "button-press-event") do widget, event 
    if hasselection(selection)
        for i in eachindex(userArray) 
            if userArray[i].userID == ls[selected(selection),1]
                openMessageWindow(userArray[i])
                println(userArray[i])
            end
        end
        
    end
end

signal_connect(add, "button-press-event") do widget, event 
    friendID = get_gtk_property(b["entry2"], :text, String)
    println(ls[selected(selection),1])
    if hasselection(selection)
        friend = nothing
        for j in eachindex(userArray) 
            if userArray[j].userID == friendID
                friend = userArray[j]
                println(friend)
            end
        end
        
        if friend !== nothing
            for i in eachindex(userArray) 
                if userArray[i].userID == ls[selected(selection),1]
                    setFrind(friend, userArray[i])
                    println(userArray[i])
                end
            end
        end
    end
end

signal_connect(registerBu, "button-press-event") do widget, event
    newUsername = get_gtk_property(b["entry1"], :text, String)
    newUser = User(newUsername, [], [])
    push!(userArray, newUser)
    push!(ls, (get_gtk_property(b["entry1"], :text, String), ))
    println(userArray)
end
showall(win)

function openMessageWindow(user)
    win = GtkWindow("Post Message")
    hbox = GtkBox(:v)
    b = GtkButton("Send")
    ent = GtkEntry()

    push!(hbox, ent, b)
    push!(win, hbox)

    signal_connect(b, "button-press-event") do widget, event
        message = get_gtk_property(ent, :text, String)
        push!(user.message, message)
        println(user)
    end

    showall(win)
end

function sendFriendPost(user)
    win = GtkWindow("See Message")
    ls = GtkListStore(String, String)

    for i in  eachindex(user.friends)
        for j in eachindex(user.friends[i].message) 
            push!(ls,(user.friends[i].userID, user.friends[i].message[j]))
        end
    end

    tv = GtkTreeView(GtkTreeModel(ls))
    rTxt = GtkCellRendererText()
    c1 = GtkTreeViewColumn("Friend", rTxt, Dict([("text",0)]))
    c2 = GtkTreeViewColumn("Message", rTxt, Dict([("text",1)]))
    push!(tv, c1, c2)

    push!(win, tv)
    showall(win)
end

