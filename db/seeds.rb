def fake_blogs(user_id)    # create 3 blogs for test user
  3.times do
      blog = Blog.create(
        title: Faker::Book.title,
        description: Faker::Lorem.sentence,
        user_id: user_id
      )
      # for each blog, create 20 posts
      20.times do
        blog.posts.create(
          title: Faker::Lorem.sentence,
          content: "<h2>My next post</h2><p>#{Faker::Lovecraft.paragraph(20)}</p>",
          published: Faker::Boolean.boolean(0.9),
          publish_date: Faker::Date.between(Date.today, 5.days.from_now)
        )
      end    
    end
end

# Create 1 test user
User.create(
  first_name: 'Example',
  last_name: 'User',
  email: 'example@example.com',
  password: '123456',
  password_confirmation: '123456'
)

fake_blogs(User.last.id)

# Create 4 more random users
4.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123456',
    password_confirmation: '123456'
  )
  fake_blogs(User.last.id)
end




