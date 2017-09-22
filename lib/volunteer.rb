class Volunteer
  attr_reader :name, :id, :project_id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    @id = attributes.fetch(:id)
  end

  def ==(another_volunteer)
    (self.name.==another_volunteer.name).&(self.id.==another_volunteer.id).&(self.project_id.==another_volunteer.project_id)
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      project_id = volunteer.fect("project_id").to_i
      volunteers.push(Volunteer.new({:name => name, :id => id, :project_id => project_id}))
    end
    volunteers
  end

  def save
    volunteer = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}','#{@project_id}') RETURNING id;")
    @id = volunteer.first.fetch("id").to_i
    ##why isn't it project_id ? compared to doc/patient assignment
    @project_id = volunteer.first.fetch("project_id").to_i
  end

  def self.find(id)
    volunteers = DB.exec("SELECT * FROM volunteers WHERE id = #{id};")
    name = volunteers.first.fetch("name")
    id = volunteers.first.fetch("id").to_i
    project_id = volunteers.first.fetch("project_id").to_i
    Volunteer.new({:name => name, :id => id, :project_id => project_id})
  end

end
