using Godot;
using System;

public partial class Area2d : Area2D
{
    public override void _Ready()
    {
        //Connect("body_entered", this, "_on_Area2D_body_entered");
    }

    public void _on_Area2D_body_entered(Node body)
    {
        if (body is CharacterBody2D)
        {
            GD.Print(body.Name + " 碰撞，角色将被删除");
            body.QueueFree(); // 删除角色
        }
    }
}
