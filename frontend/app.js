const taskInput = document.getElementById("taskInput");
const addBtn = document.getElementById("addBtn");
const todoList = document.getElementById("todoList");

function fetchTodos() {
  fetch("/todos")
    .then(res => res.json())
    .then(todos => {
      todoList.innerHTML = "";
      todos.forEach(todo => {
        const li = document.createElement("li");
        li.textContent = todo.task;

        const delBtn = document.createElement("button");
        delBtn.textContent = "Delete";
        delBtn.onclick = () => deleteTodo(todo.task);

        li.appendChild(delBtn);
        todoList.appendChild(li);
      });
    })
    .catch(err => {
      console.error("Error fetching todos:", err);
    });
}

function addTodo() {
  const task = taskInput.value.trim();
  if (!task) return;

  fetch("/todos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ task }),
  })
    .then(res => {
      if (!res.ok) throw new Error("Failed to add task");
      return res.json();
    })
    .then(() => {
      taskInput.value = "";
      fetchTodos();
    })
    .catch(err => {
      console.error("Error adding todo:", err);
    });
}

function deleteTodo(task) {
  fetch(`/todos/${encodeURIComponent(task)}`, { method: "DELETE" })
    .then(res => {
      if (!res.ok) throw new Error("Failed to delete task");
      fetchTodos();
    })
    .catch(err => {
      console.error("Error deleting todo:", err);
    });
}

addBtn.addEventListener("click", addTodo);
window.onload = fetchTodos;

