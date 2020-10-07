class Student
  attr_accessor :name, :grade
  attr_reader :id
  
  #DB[:conn]
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql= <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
      SQL
    DB[:conn].execute(sql)
  end
  
  def save #instantiating a new instance of the Student class
    sql = <<-SQL #inserting a new row into the db table
      INSERT INTO students (name, grade)
      VALUES (?, ?) 
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #using a SQL query to grab the value of the ID column of the last inserted row and set that equal to the given student instance's id attribute. 
  end
  
  def self.create(name:, grade:) #passing through attribute hashes
    student = Student.new(name, grade)
    student.save
    student
  end
  #using the keyword arguments to instantiate a new student, then use the save method to persist that student into the db
    
end
