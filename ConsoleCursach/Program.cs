namespace BSBDCURSACH
{
    using Npgsql;
    internal class Program
    {
        public static NpgsqlConnection Login(string connectionString)
        {
            var connection = new NpgsqlConnection(connectionString);
            try
            {
                connection.Open();  
            } catch{}
            if (connection.State == System.Data.ConnectionState.Open)
            {
                return connection;
            }
            return null;
        }
        public static void hr_interface(NpgsqlConnection connection)
        {
            while(true)
            {
                Console.Clear();
                Console.WriteLine($"1. Список сотрудников \n2. Добавить сотрудника \n3. Изменить данные сотрудника \n4. Удалить сотрудника \n0. Выйти из приложения");
                var pressKey = Console.ReadKey().KeyChar;
                Console.Clear();
                switch(pressKey)
                {
                    case '1':
                        using(var command1 = new NpgsqlCommand("SELECT * FROM Workers", connection))
                        using(var reader = command1.ExecuteReader()){
                        var columnNames = new string[reader.FieldCount];
                        var columnWidths = new int[reader.FieldCount];
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            columnNames[i] = reader.GetName(i);
                            columnWidths[i] = Math.Max(columnNames[i].Length, 15);
                        }
                        foreach (int width in columnWidths)
                        {
                            Console.Write("+" + new string('-', width + 2));
                        }
                        Console.WriteLine("+");
                        for (int i = 0; i < columnNames.Length; i++)
                        {
                            Console.Write("| " + columnNames[i].PadRight(columnWidths[i]) + " ");
                        }
                        Console.WriteLine("|");
                        foreach (int width in columnWidths)
                        {
                            Console.Write("+" + new string('-', width + 2));
                        }
                        Console.WriteLine("+");
                        while (reader.Read())
                        {
                            var rowValues = new string[reader.FieldCount];
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                var value = reader[i];
                                rowValues[i] = value == DBNull.Value ? "NULL" : value.ToString();
                                if (rowValues[i].Length > columnWidths[i] - 2)
                                {
                                    rowValues[i] = rowValues[i].Substring(0, columnWidths[i] - 5) + "...";
                                }
                            }
                            for (int i = 0; i < rowValues.Length; i++)
                            {
                                Console.Write("| " + rowValues[i].PadRight(columnWidths[i]) + " ");
                            }
                            Console.WriteLine("|");
                        }
                        foreach (int width in columnWidths)
                        {
                            Console.Write("+" + new string('-', width + 2));
                        }
                        Console.WriteLine("+");
                        }
                        break;
                    case '2':
                        Console.WriteLine("Введите имя");
                        string name = Console.ReadLine();
                        Console.WriteLine("Введите фамилию");
                        string surname = Console.ReadLine();
                        Console.WriteLine("Введите отчество (если есть)");
                        string patronymic = Console.ReadLine();
                        Console.WriteLine("Введите должность");
                        string job = Console.ReadLine();
                        Console.WriteLine("Введите паспорт");
                        string pasport = Console.ReadLine();
                        string query = $@"
                        INSERT INTO Workers (
                            name_worker,
                            surname_worker,
                            patronymic_worker,
	                        job_worker,
	                        pasport_worker
                        )
                        VALUES
                            ('{name}', '{surname}', '{patronymic}', '{job}', {pasport});";
                        if (patronymic == "")
                        {
                            query = $@"
                        INSERT INTO Workers (
                            name_worker,
                            surname_worker,
                            patronymic_worker,
	                        job_worker,
	                        pasport_worker
                        )
                        VALUES
                            ('{name}', '{surname}', null, '{job}', {pasport});";
                        }
                        var command = new NpgsqlCommand(query, connection);
                        try{command.ExecuteScalar();} catch{Console.WriteLine("Ошибка! Убедитесь что вы указали правильный формат данных");}
                        break;
                    case '3':
                        query = "_";
                        Console.WriteLine("Введите id сотрудника");
                        string id = Console.ReadLine();
                        Console.WriteLine($"Какую информацию нужно изменить?\n1. Имя\n2. Фамилию\n3. Отчество\n4. Должность\n5. Паспорт");
                        switch (Console.ReadKey().KeyChar)
                        {
                            case '1':
                                Console.WriteLine("Введите новое имя");
                                string new_name = Console.ReadLine();
                                query = $"UPDATE Workers SET name_worker = '{new_name}' WHERE worker_id = {id}";
                                break;
                            case '2':
                                Console.WriteLine("Введите новую фамилию");
                                string new_surname = Console.ReadLine();
                                query = $"UPDATE Workers SET surname_worker = '{new_surname}' WHERE worker_id = {id}";
                                break;
                            case '3':
                                Console.WriteLine("Введите новое отчество");
                                string new_patronymic = Console.ReadLine();
                                query = $"UPDATE Workers SET patronymic_worker = '{new_patronymic}' WHERE worker_id = {id}";
                                break;
                            case '4':
                                Console.WriteLine("Введите новую должность");
                                string new_job = Console.ReadLine();
                                query = $"UPDATE Workers SET job_worker = '{new_job}' WHERE worker_id = {id}";
                                break;
                            case '5':
                                Console.WriteLine("Введите новый паспорт");
                                string new_pasport = Console.ReadLine();
                                query = $"UPDATE Workers SET pasport_worker = '{new_pasport}' WHERE worker_id = {id}";
                                break;
                        }
                        if (query == "_")
                        {
                            break;
                        }
                        command = new NpgsqlCommand(query, connection);
                        try{command.ExecuteScalar();}catch{Console.WriteLine("Ошибка! Убедитесь что вы указали правильный id и формат данных и попробуйте снова");}
                        break;
                    case '4':
                        Console.WriteLine("Введите id сотрудника для удаления");
                        id = Console.ReadLine();
                        if (id == null)
                        {
                            break;
                        }
                        query = $"DELETE FROM Workers WHERE worker_id = {id}";
                        command = new NpgsqlCommand(query, connection);
                        try{command.ExecuteScalar();} catch{Console.WriteLine("Ошибка! Убедитесь что вы указали правильный id и попробуйте снова");}
                        break;
                    case '0':
                        Environment.Exit(0);
                        break;
                }
                Console.WriteLine("Нажмите чтобы продолжить...");
                Console.ReadKey();
            }
        }
        static void Main(string[] args)
        {
            NpgsqlConnection connection;
            object role = "1";
            while(role == "1"){
            Console.WriteLine($"1. Войти в пользователя \n0. Выйти из приложения");
            var pressKey = Console.ReadKey().KeyChar;
            switch(pressKey)
            {
                case '1':
                    Console.Clear();
                    Console.WriteLine("Введите логин:");
                    string? username = Console.ReadLine();
                    Console.WriteLine("Введите пароль:");
                    string? password = Console.ReadLine();
                    Console.Clear();
                    if (username == null | password == null)
                        {
                            Console.WriteLine("Логин и пароль не могут быть пустыми!");
                            Console.ReadKey();
                            break;
                        }
                    connection = Login($"Host=localhost;Username={username};Password={password};Database=CARGOCORP");
                    if (connection != null)
                    {
                        Console.WriteLine($"Подключение успешно! \nНажмите чтобы продолжить...");
                        Console.ReadKey();
                        var cmd = new NpgsqlCommand("SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member')", connection);
                        role = cmd.ExecuteScalar();
                        if (role.ToString() == "hr_role")
                            {
                                hr_interface(connection);
                            }
                        break;
                    }
                    Console.WriteLine($"Подключение не успешно, попробуйте еще раз. \nНажмите чтобы продолжить...");
                    Console.ReadKey();
                    break;
                case '0':
                    Environment.Exit(0);
                    break;
            }
            Console.Clear();
        }
            
        }
    }
}