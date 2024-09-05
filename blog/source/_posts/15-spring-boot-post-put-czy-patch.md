---
title: '#15 Spring Boot - POST, PUT czy PATCH?'
tags:
  - http
  - patch
  - post
  - put
  - spring
  - spring boot
id: '1739'
categories:
  - - Spring Boot
date: 2017-06-09 16:00:01
author: 'Krzysztof Chruściel'
---

[![](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)](http://codecouple.pl/wp-content/uploads/2017/02/springBootArt.png)

Tak na prawdę ten artykuł niekoniecznie musi być związany ze **Spring Bootem**, jednakże posłuży mi on jako realizacja tego zagadnienia. Projektując **API REST'owe** powinniśmy zwracać uwagę na wiele elementów. Odpowiedni dobór nazw dla endpointów czy korzystanie z kodów odpowiedzi **HTTP** świadczy o dobrze zaprojektowanym **API**. Ważnym element jest także korzystanie z metod **HTTP** do obsługi zasobów.
<!-- more -->
### 1\. POST

Metoda **POST** służy do dodawania **nowych** elementów. Nowych, czyli takich, których **ID** jest jeszcze nieznane. Po utworzeniu obiektu należy zwrócić kod **201 "Created"**.

Metoda **POST**:

@PostMapping
@ResponseStatus(value = HttpStatus.CREATED, reason = "Todo created!")
public void addNewTodo(@RequestBody Todo todo){
    todoService.addNewTodo(todo);
}

Test do metody **POST**:

@Test
public void shouldAddNewTodo() throws Exception {
    // Given
    Todo todo = new Todo("Title", "Description");
    // When
    ResultActions result = this.mvc.perform(post("/todos")
            .contentType(MediaType.APPLICATION\_JSON\_UTF8)
            .content(objectMapper.writeValueAsString(todo)));
    // Then
    result.andExpect(status().isCreated())
            .andExpect(status().reason("Todo created!"));
}

### 2. PUT

Metoda **PUT** jest bardzo podobna do metody **POST**, ponieważ także wysyłamy cały obiekt. Istotną różnicą jest to, że metody **PUT** używamy wtedy, kiedy **ID** danego obiektu pochodzi od klienta. Czyli **PUT** powinien służyć do aktualizowania zasobu. **Bardzo ważne jest to, że w przypadku tego mechanizmu podmieniany jest cały obiekt!** Po aktualizacji należy zwróć kod **204 "No content"**.

Metoda **PUT**:

@PutMapping("/{id}")
public ResponseEntity<Void> updateTodo(@RequestBody Todo todo, @PathVariable Long id) throws TodoNotFound {
    Todo todoById = todoService.getTodoById(id);
    if(todoById == null){
        todoService.addNewTodo(todo);
        return ResponseEntity.created(URI.create(String.format("/todos/%d", id))).build();
    }
    todoService.update(todo);
    return ResponseEntity.noContent().build();
}

Test do metody **PUT**:

@Test
public void shouldCreateNewTodoWhenTryToUpdate() throws Exception {
    // Given
    given(todoService.getTodoById(anyLong())).willReturn(null);
    Todo todo = new Todo("New Title", "New Description");
    // When
    ResultActions result = this.mvc.perform(put("/todos/10")
            .contentType(MediaType.APPLICATION\_JSON\_VALUE)
            .content(objectMapper.writeValueAsString(todo)));
    // Then
    result.andExpect(status().isCreated());
}


@Test
public void shouldUpdateTodo() throws Exception {
    // Given
    Todo todo = new Todo(1L, "title", "desc");
    given(todoService.getTodoById(1L)).willReturn(todo);
    // When
    ResultActions result = this.mvc.perform(put("/todos/1")
            .contentType(MediaType.APPLICATION\_JSON\_UTF8)
            .content(objectMapper.writeValueAsString(todo)));
    // Then
    result.andExpect(status().isNoContent());
}

### 3. PATCH

O metodzie **PUT** pisałem, że powinna być wykorzystywana do aktualizacji całego obiektu, ale co w przypadku, gdy chcę zaktualizować tylko część zasobu? Do częściowej aktualizacji służy metoda **PATCH**. Po wykonaniu operacji należy zwróć kod **204 "No content"**.

Metoda **PATCH**:

@PatchMapping("/{id}")
@ResponseStatus(value = HttpStatus.NO\_CONTENT, reason = "Todo partial updated!")
public void updateTodo(@RequestBody Map<String, Object> updates, @PathVariable Long id) throws TodoNotFound {
    Todo todo = todoService.getTodoById(id);
    if (todo == null) {
        throw new TodoNotFound(String.format("Todo with ID %d not exists!", id));
    }
    partialUpdate(todo, updates);
}

private void partialUpdate(Todo todo, Map<String, Object> updates) {
    if (updates.containsKey("title")) {
        todo.setTitle((String) updates.get("title"));
    }
    if (updates.containsKey("description")) {
        todo.setDescription((String) updates.get("description"));
    }
    todoService.partialUpdated(todo);
}

Test do metody **PATCH**:

@Test
public void shouldReturn404WhenTryPartialUpdateTodoWhichNotExists() throws Exception {
    // Given
    given(todoService.getTodoById(anyLong())).willReturn(null);
    HashMap<String, Object> updates = new HashMap<>();
    updates.put("description", "new description");
    // When
    ResultActions result = this.mvc.perform(patch("/todos/10")
            .contentType(MediaType.APPLICATION\_JSON\_VALUE)
            .content(objectMapper.writeValueAsString(updates)));
    // Then
    result.andExpect(status().isNotFound());
}

@Test
public void shouldPartialUpdateTodo() throws Exception {
    // Given
    Todo todo = new Todo(1L, "title", "desc");
    given(todoService.getTodoById(1L)).willReturn(todo);
    HashMap<String, Object> updates = new HashMap<>();
    updates.put("title", "new title");
    updates.put("description", "new description");
    // When
    ResultActions result = this.mvc.perform(patch("/todos/1")
            .contentType(MediaType.APPLICATION\_JSON\_UTF8)
            .content(objectMapper.writeValueAsString(updates)));
    // Then
    result.andExpect(status().isNoContent())
            .andExpect(status().reason("Todo partial updated!"));
}

### 4. Którą wybrać?

Zgodnie z powyższymi akapitami, jeśli dodajemy całkiem nowy zasób to korzystamy z **POST**. Jeśli chcemy zaktualizować cały element korzystamy z **PUT**, natomiast **PATCH** wykorzystujemy do częściowej aktualizacji. Całość na [GitHubie](https://github.com/kchrusciel/Spring-Boot-Examples/tree/master/spring-boot-update-example).