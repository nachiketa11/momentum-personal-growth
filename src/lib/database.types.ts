export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: { Row: { id: string; display_name: string; created_at: string }; Insert: { id: string; display_name?: string }; Update: { display_name?: string }; Relationships: [] };
      habits: { Row: { id: string; user_id: string; title: string; category: string; target_per_week: number; archived: boolean; created_at: string }; Insert: { user_id: string; title: string; category?: string; target_per_week?: number }; Update: { title?: string; category?: string; target_per_week?: number; archived?: boolean }; Relationships: [] };
      habit_logs: { Row: { id: string; user_id: string; habit_id: string; log_date: string; completed: boolean; created_at: string }; Insert: { user_id: string; habit_id: string; log_date: string; completed?: boolean }; Update: { completed?: boolean }; Relationships: [] };
      goals: { Row: { id: string; user_id: string; title: string; description: string; target_date: string | null; status: "active" | "completed" | "paused"; created_at: string }; Insert: { user_id: string; title: string; description?: string; target_date?: string | null }; Update: { title?: string; description?: string; target_date?: string | null; status?: "active" | "completed" | "paused" }; Relationships: [] };
      journal_entries: { Row: { id: string; user_id: string; title: string; body: string; mood: number | null; created_at: string }; Insert: { user_id: string; title?: string; body: string; mood?: number | null }; Update: { title?: string; body?: string; mood?: number | null }; Relationships: [] };
      future_self_letters: { Row: { id: string; user_id: string; title: string; open_at: string; created_at: string }; Insert: { user_id: string; title: string; open_at: string }; Update: never; Relationships: [] };
      future_self_letter_contents: { Row: { letter_id: string; user_id: string; body: string; created_at: string }; Insert: { letter_id: string; user_id: string; body: string }; Update: never; Relationships: [] };
    };
    Views: Record<string, never>; Functions: Record<string, never>; Enums: Record<string, never>; CompositeTypes: Record<string, never>;
  };
}
