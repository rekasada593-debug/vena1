
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL!
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Database types
export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          password: string
          full_name: string
          company_name?: string
          role: 'Admin' | 'Member'
          permissions?: string[]
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['users']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['users']['Insert']>
      }
      profiles: {
        Row: {
          id: string
          admin_user_id: string
          full_name: string
          email: string
          phone: string
          company_name: string
          website: string
          address: string
          bank_account: string
          authorized_signer: string
          id_number?: string
          bio: string
          income_categories: string[]
          expense_categories: string[]
          project_types: string[]
          event_types: string[]
          asset_categories: string[]
          sop_categories: string[]
          package_categories: string[]
          project_status_config: any[]
          notification_settings: any
          security_settings: any
          briefing_template: string
          terms_and_conditions?: string
          contract_template?: string
          logo_base64?: string
          brand_color?: string
          public_page_config: any
          package_share_template?: string
          booking_form_template?: string
          chat_templates?: any[]
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['profiles']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['profiles']['Insert']>
      }
      clients: {
        Row: {
          id: string
          name: string
          email: string
          phone: string
          whatsapp?: string
          since: string
          instagram?: string
          status: string
          client_type: string
          last_contact: string
          portal_access_id: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['clients']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['clients']['Insert']>
      }
      leads: {
        Row: {
          id: string
          name: string
          contact_channel: string
          location: string
          status: string
          date: string
          notes?: string
          whatsapp?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['leads']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['leads']['Insert']>
      }
      packages: {
        Row: {
          id: string
          name: string
          price: number
          category: string
          physical_items: any[]
          digital_items: string[]
          processing_time: string
          default_printing_cost?: number
          default_transport_cost?: number
          photographers?: string
          videographers?: string
          cover_image?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['packages']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['packages']['Insert']>
      }
      add_ons: {
        Row: {
          id: string
          name: string
          price: number
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['add_ons']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['add_ons']['Insert']>
      }
      team_members: {
        Row: {
          id: string
          name: string
          role: string
          email: string
          phone: string
          standard_fee: number
          no_rek?: string
          reward_balance: number
          rating: number
          performance_notes: any[]
          portal_access_id: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['team_members']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['team_members']['Insert']>
      }
      projects: {
        Row: {
          id: string
          project_name: string
          client_name: string
          client_id: string
          project_type: string
          package_name: string
          package_id: string
          add_ons: any[]
          date: string
          deadline_date?: string
          location: string
          progress: number
          status: string
          active_sub_statuses?: string[]
          total_cost: number
          amount_paid: number
          payment_status: string
          team: any[]
          notes?: string
          accommodation?: string
          drive_link?: string
          client_drive_link?: string
          final_drive_link?: string
          start_time?: string
          end_time?: string
          image?: string
          revisions?: any[]
          promo_code_id?: string
          discount_amount?: number
          shipping_details?: string
          dp_proof_url?: string
          printing_details?: any[]
          printing_cost?: number
          transport_cost?: number
          is_editing_confirmed_by_client?: boolean
          is_printing_confirmed_by_client?: boolean
          is_delivery_confirmed_by_client?: boolean
          confirmed_sub_statuses?: string[]
          client_sub_status_notes?: any
          sub_status_confirmation_sent_at?: any
          completed_digital_items?: string[]
          invoice_signature?: string
          custom_sub_statuses?: any[]
          booking_status?: string
          rejection_reason?: string
          chat_history?: any[]
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['projects']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['projects']['Insert']>
      }
      transactions: {
        Row: {
          id: string
          date: string
          description: string
          amount: number
          type: string
          project_id?: string
          category: string
          method: string
          pocket_id?: string
          card_id?: string
          printing_item_id?: string
          vendor_signature?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['transactions']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['transactions']['Insert']>
      }
      financial_pockets: {
        Row: {
          id: string
          name: string
          description: string
          icon: string
          type: string
          amount: number
          goal_amount?: number
          lock_end_date?: string
          members?: any[]
          source_card_id?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['financial_pockets']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['financial_pockets']['Insert']>
      }
      cards: {
        Row: {
          id: string
          card_holder_name: string
          bank_name: string
          card_type: string
          last_four_digits: string
          expiry_date?: string
          balance: number
          color_gradient: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['cards']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['cards']['Insert']>
      }
      assets: {
        Row: {
          id: string
          name: string
          category: string
          purchase_date: string
          purchase_price: number
          serial_number?: string
          status: string
          notes?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['assets']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['assets']['Insert']>
      }
      contracts: {
        Row: {
          id: string
          contract_number: string
          client_id: string
          project_id: string
          signing_date: string
          signing_location: string
          client_name1: string
          client_address1: string
          client_phone1: string
          client_name2?: string
          client_address2?: string
          client_phone2?: string
          shooting_duration: string
          guaranteed_photos: string
          album_details: string
          digital_files_format: string
          other_items: string
          personnel_count: string
          delivery_timeframe: string
          dp_date: string
          final_payment_date: string
          cancellation_policy: string
          jurisdiction: string
          vendor_signature?: string
          client_signature?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['contracts']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['contracts']['Insert']>
      }
      promo_codes: {
        Row: {
          id: string
          code: string
          discount_type: string
          discount_value: number
          is_active: boolean
          usage_count: number
          max_usage?: number
          expiry_date?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['promo_codes']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['promo_codes']['Insert']>
      }
      sops: {
        Row: {
          id: string
          title: string
          category: string
          content: string
          last_updated: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['sops']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['sops']['Insert']>
      }
      notifications: {
        Row: {
          id: string
          title: string
          message: string
          timestamp: string
          is_read: boolean
          icon: string
          link?: any
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['notifications']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['notifications']['Insert']>
      }
      client_feedback: {
        Row: {
          id: string
          client_name: string
          satisfaction: string
          rating: number
          feedback: string
          date: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['client_feedback']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['client_feedback']['Insert']>
      }
      social_media_posts: {
        Row: {
          id: string
          project_id: string
          client_name: string
          post_type: string
          platform: string
          scheduled_date: string
          caption: string
          media_url?: string
          status: string
          notes?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['social_media_posts']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['social_media_posts']['Insert']>
      }
      team_project_payments: {
        Row: {
          id: string
          project_id: string
          team_member_name: string
          team_member_id: string
          date: string
          status: string
          fee: number
          reward?: number
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['team_project_payments']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['team_project_payments']['Insert']>
      }
      team_payment_records: {
        Row: {
          id: string
          record_number: string
          team_member_id: string
          date: string
          project_payment_ids: string[]
          total_amount: number
          vendor_signature?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['team_payment_records']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['team_payment_records']['Insert']>
      }
      reward_ledger_entries: {
        Row: {
          id: string
          team_member_id: string
          date: string
          description: string
          amount: number
          project_id?: string
          created_at: string
          updated_at: string
        }
        Insert: Omit<Database['public']['Tables']['reward_ledger_entries']['Row'], 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['reward_ledger_entries']['Insert']>
      }
    }
  }
}
