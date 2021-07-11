class Follows::Create < ActiveInteraction::Base
  object :user
  object :followee, class: User

  def execute
    Follow.transaction do
      follow = Follow.create(
        user: user,
        followee: followee
      )

      if follow.invalid?
        errors.merge!(follow.errors)
        raise ActiveRecord::Rollback
      end

      follow
    end
  end
end
