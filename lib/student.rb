class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    # binding.pry
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
                SELECT * FROM students
            SQL
    DB[:conn].execute(sql).map do |ele| 
      self.new_from_db(ele)
    end  
  end

  def self.find_by_name(name)
    sql = <<-SQL  
                  SELECT * FROM students WHERE name = ? LIMIT 1
            SQL
    DB[:conn].execute(sql,name).map do |record|
      self.new_from_db(record)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
                  SELECT * FROM students WHERE grade = 9
             SQL
    result = DB[:conn].execute(sql)
      result.map do |record|
        self.new_from_db(record)
      end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
                  SELECT * FROM students WHERE grade < 12
             SQL
    result = DB[:conn].execute(sql)
      result.map do |record|
        self.new_from_db(record)
      end
  end

  def self.first_X_students_in_grade_10(number)    
    sql = <<-SQL
                  SELECT * FROM students WHERE grade = 10 LIMIT ?
             SQL
    result = DB[:conn].execute(sql,number)
      result.map do |record|
        self.new_from_db(record)
      end
  end

  def self.first_student_in_grade_10    
    number = 1
    sql = <<-SQL
                  SELECT * FROM students WHERE grade = 10 LIMIT ?
             SQL
    result = DB[:conn].execute(sql,number)
    
      
        self.new_from_db(result[0])
       
      
  end
  def self.all_students_in_grade_X(number)
    sql = <<-SQL
            SELECT * FROM students WHERE grade = ?
              SQL
              result = DB[:conn].execute(sql,number)
              result.map do |record|
                self.new_from_db(record)
                end
    end
end
