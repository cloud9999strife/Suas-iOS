//
//  ViewController.swift
//  TodoSampleApp-Mac
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Cocoa
import Suas

class ViewController: NSViewController, Component {

  @IBOutlet weak var todoTextField: NSTextField!
  @IBOutlet weak var todoTableView: NSTableView!

  var state: TodoState = emptyState {
    didSet {
      todoTableView.reloadData()
    }
  }

  @IBAction func todoEntered(sender: Any) {
    guard todoTextField.stringValue != "" else { return }
    store.dispatch(action: AddTodo(text: todoTextField.stringValue))
    todoTextField.stringValue = ""
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    #if swift(>=4.0)
    todoTableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "TodoCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoCell"))
    #else
    todoTableView.register(NSNib(nibNamed: "TodoCell", bundle: nil), forIdentifier: "TodoCell")
    #endif
    store.connect(component: self)
  }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return state.todos.count
  }

  func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    return 52
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let todo = state.todos[row]

    #if swift(>=4.0)
    let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoCell"), owner: nil) as! TodoCell)
    view.checkButton.state = todo.isCompleted ? NSControl.StateValue.onState : NSControl.StateValue.offState
    #else
    let view = (tableView.make(withIdentifier: "TodoCell", owner: nil) as! TodoCell)
    view.checkButton.state = todo.isCompleted ? NSOnState : NSOffState
    #endif

    view.todoLabel.stringValue = todo.title
    view.index = row
    return view
  }
}


class TodoCell: NSView {

  @IBOutlet var todoLabel: NSTextField!
  @IBOutlet var checkButton: NSButton!
  var index: Int = 0

  @IBAction func buttonTapped(_ sender: Any) {
    store.dispatch(action: ToggleTodo(index: index))
  }

}
