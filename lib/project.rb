class Project

  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
  end

  def ==(another_project)
    (self.title.==(another_project.title)).&(self.id.==(another_project.id))
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i
      if(title!="Unassigned")
        projects.push(Project.new({:title => title, :id => id}))
      end
    end
  projects
  end

  def save
    project = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = project.first.fetch("id").to_i
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    title = project.first.fetch("title")
    Project.new({:title => title, :id => id})
  end

  def update(attributes)
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{self.id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id in ( #{self.id})")
  end

  def volunteers
    volunteers = []
    results = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    results.each() do |result|
      name = result.fetch("name")
      id = result.fetch("id").to_i
      project_id = result.fetch("project_id").to_i
      volunteers.push(Volunteer.new({:name => name, :id => id, :project_id => project_id}))
    end
    volunteers
  end

end

