# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

```
root@acer-r:~# go version
go version go1.18.1 linux/amd64
root@acer-r:~#
```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 
```
user@acer-r:~/devops-netology/07-terraform-05-golang$ cat 1.go 
package main

import "fmt"

    func main() {
        fmt.Print("Enter value in foot: ")
        var input float64
        fmt.Scanf("%f", &input)
        output := input * float64(0.3048)
        fmt.Println("Value in Meters:", output)
    }
user@acer-r:~/devops-netology/07-terraform-05-golang$
```


1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

```
user@acer-r:~/devops-netology/07-terraform-05-golang$ cat 2.go 
package main

import "fmt"

    func main() {
        x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
        current := 0
        fmt.Println ("Список значений : ", x)
        for i, value := range x {
            if (i == 0) {
               current = value 
            } else {
                if (value < current){
                    current = value
                }
            }
        }
        fmt.Println("Минимальное число : ", current)
    }
user@acer-r:~/devops-netology/07-terraform-05-golang$
```

1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

```
user@acer-r:~/devops-netology/07-terraform-05-golang$ cat 3.go 
package main

import "fmt"

    func main() {

        for i := 1; i <= 100; i++ {
            if ((i-1)%10) ==0 {
                    fmt.Print(i-1," -> ")
            }

            if (i%3) == 0 {
                fmt.Print(i,", ")
                }
            if (i%10) ==0 {
                fmt.Println()
            }
        }
    }
user@acer-r:~/devops-netology/07-terraform-05-golang$
```

В виде решения ссылку на код или сам код. 

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

