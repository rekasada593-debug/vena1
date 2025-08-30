
import { supabase, Database } from '../supabase';
import * as types from '../types';

// Helper function to transform database records to app types
const transformDatabaseToApp = {
  client: (dbClient: Database['public']['Tables']['clients']['Row']): types.Client => ({
    id: dbClient.id,
    name: dbClient.name,
    email: dbClient.email,
    phone: dbClient.phone,
    whatsapp: dbClient.whatsapp,
    since: dbClient.since,
    instagram: dbClient.instagram,
    status: dbClient.status as types.ClientStatus,
    clientType: dbClient.client_type as types.ClientType,
    lastContact: dbClient.last_contact,
    portalAccessId: dbClient.portal_access_id,
  }),

  lead: (dbLead: Database['public']['Tables']['leads']['Row']): types.Lead => ({
    id: dbLead.id,
    name: dbLead.name,
    contactChannel: dbLead.contact_channel as types.ContactChannel,
    location: dbLead.location,
    status: dbLead.status as types.LeadStatus,
    date: dbLead.date,
    notes: dbLead.notes,
    whatsapp: dbLead.whatsapp,
  }),

  package: (dbPackage: Database['public']['Tables']['packages']['Row']): types.Package => ({
    id: dbPackage.id,
    name: dbPackage.name,
    price: Number(dbPackage.price),
    category: dbPackage.category,
    physicalItems: dbPackage.physical_items as types.PhysicalItem[],
    digitalItems: dbPackage.digital_items,
    processingTime: dbPackage.processing_time,
    defaultPrintingCost: dbPackage.default_printing_cost ? Number(dbPackage.default_printing_cost) : undefined,
    defaultTransportCost: dbPackage.default_transport_cost ? Number(dbPackage.default_transport_cost) : undefined,
    photographers: dbPackage.photographers,
    videographers: dbPackage.videographers,
    coverImage: dbPackage.cover_image,
  }),

  project: (dbProject: Database['public']['Tables']['projects']['Row']): types.Project => ({
    id: dbProject.id,
    projectName: dbProject.project_name,
    clientName: dbProject.client_name,
    clientId: dbProject.client_id,
    projectType: dbProject.project_type,
    packageName: dbProject.package_name,
    packageId: dbProject.package_id,
    addOns: dbProject.add_ons as types.AddOn[],
    date: dbProject.date,
    deadlineDate: dbProject.deadline_date,
    location: dbProject.location,
    progress: dbProject.progress,
    status: dbProject.status,
    activeSubStatuses: dbProject.active_sub_statuses,
    totalCost: Number(dbProject.total_cost),
    amountPaid: Number(dbProject.amount_paid),
    paymentStatus: dbProject.payment_status as types.PaymentStatus,
    team: dbProject.team as types.AssignedTeamMember[],
    notes: dbProject.notes,
    accommodation: dbProject.accommodation,
    driveLink: dbProject.drive_link,
    clientDriveLink: dbProject.client_drive_link,
    finalDriveLink: dbProject.final_drive_link,
    startTime: dbProject.start_time,
    endTime: dbProject.end_time,
    image: dbProject.image,
    revisions: dbProject.revisions as types.Revision[],
    promoCodeId: dbProject.promo_code_id,
    discountAmount: dbProject.discount_amount ? Number(dbProject.discount_amount) : undefined,
    shippingDetails: dbProject.shipping_details,
    dpProofUrl: dbProject.dp_proof_url,
    printingDetails: dbProject.printing_details as types.PrintingItem[],
    printingCost: dbProject.printing_cost ? Number(dbProject.printing_cost) : undefined,
    transportCost: dbProject.transport_cost ? Number(dbProject.transport_cost) : undefined,
    isEditingConfirmedByClient: dbProject.is_editing_confirmed_by_client,
    isPrintingConfirmedByClient: dbProject.is_printing_confirmed_by_client,
    isDeliveryConfirmedByClient: dbProject.is_delivery_confirmed_by_client,
    confirmedSubStatuses: dbProject.confirmed_sub_statuses,
    clientSubStatusNotes: dbProject.client_sub_status_notes as Record<string, string>,
    subStatusConfirmationSentAt: dbProject.sub_status_confirmation_sent_at as Record<string, string>,
    completedDigitalItems: dbProject.completed_digital_items,
    invoiceSignature: dbProject.invoice_signature,
    customSubStatuses: dbProject.custom_sub_statuses as types.SubStatusConfig[],
    bookingStatus: dbProject.booking_status as types.BookingStatus,
    rejectionReason: dbProject.rejection_reason,
    chatHistory: dbProject.chat_history as types.ChatMessage[],
  }),
};

// Helper function to transform app types to database format
const transformAppToDatabase = {
  client: (client: Omit<types.Client, 'id'>): Database['public']['Tables']['clients']['Insert'] => ({
    name: client.name,
    email: client.email,
    phone: client.phone,
    whatsapp: client.whatsapp,
    since: client.since,
    instagram: client.instagram,
    status: client.status,
    client_type: client.clientType,
    last_contact: client.lastContact,
    portal_access_id: client.portalAccessId,
  }),

  lead: (lead: Omit<types.Lead, 'id'>): Database['public']['Tables']['leads']['Insert'] => ({
    name: lead.name,
    contact_channel: lead.contactChannel,
    location: lead.location,
    status: lead.status,
    date: lead.date,
    notes: lead.notes,
    whatsapp: lead.whatsapp,
  }),

  package: (pkg: Omit<types.Package, 'id'>): Database['public']['Tables']['packages']['Insert'] => ({
    name: pkg.name,
    price: pkg.price,
    category: pkg.category,
    physical_items: pkg.physicalItems,
    digital_items: pkg.digitalItems,
    processing_time: pkg.processingTime,
    default_printing_cost: pkg.defaultPrintingCost,
    default_transport_cost: pkg.defaultTransportCost,
    photographers: pkg.photographers,
    videographers: pkg.videographers,
    cover_image: pkg.coverImage,
  }),

  project: (project: Omit<types.Project, 'id'>): Database['public']['Tables']['projects']['Insert'] => ({
    project_name: project.projectName,
    client_name: project.clientName,
    client_id: project.clientId,
    project_type: project.projectType,
    package_name: project.packageName,
    package_id: project.packageId,
    add_ons: project.addOns,
    date: project.date,
    deadline_date: project.deadlineDate,
    location: project.location,
    progress: project.progress,
    status: project.status,
    active_sub_statuses: project.activeSubStatuses,
    total_cost: project.totalCost,
    amount_paid: project.amountPaid,
    payment_status: project.paymentStatus,
    team: project.team,
    notes: project.notes,
    accommodation: project.accommodation,
    drive_link: project.driveLink,
    client_drive_link: project.clientDriveLink,
    final_drive_link: project.finalDriveLink,
    start_time: project.startTime,
    end_time: project.endTime,
    image: project.image,
    revisions: project.revisions,
    promo_code_id: project.promoCodeId,
    discount_amount: project.discountAmount,
    shipping_details: project.shippingDetails,
    dp_proof_url: project.dpProofUrl,
    printing_details: project.printingDetails,
    printing_cost: project.printingCost,
    transport_cost: project.transportCost,
    is_editing_confirmed_by_client: project.isEditingConfirmedByClient,
    is_printing_confirmed_by_client: project.isPrintingConfirmedByClient,
    is_delivery_confirmed_by_client: project.isDeliveryConfirmedByClient,
    confirmed_sub_statuses: project.confirmedSubStatuses,
    client_sub_status_notes: project.clientSubStatusNotes,
    sub_status_confirmation_sent_at: project.subStatusConfirmationSentAt,
    completed_digital_items: project.completedDigitalItems,
    invoice_signature: project.invoiceSignature,
    custom_sub_statuses: project.customSubStatuses,
    booking_status: project.bookingStatus,
    rejection_reason: project.rejectionReason,
    chat_history: project.chatHistory,
  }),
};

// Database service class
export class DatabaseService {
  // CLIENTS CRUD
  static async getClients(): Promise<types.Client[]> {
    const { data, error } = await supabase
      .from('clients')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(transformDatabaseToApp.client);
  }

  static async createClient(client: Omit<types.Client, 'id'>): Promise<types.Client> {
    const { data, error } = await supabase
      .from('clients')
      .insert(transformAppToDatabase.client(client))
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.client(data);
  }

  static async updateClient(id: string, updates: Partial<types.Client>): Promise<types.Client> {
    const { data, error } = await supabase
      .from('clients')
      .update(transformAppToDatabase.client(updates as Omit<types.Client, 'id'>))
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.client(data);
  }

  static async deleteClient(id: string): Promise<void> {
    const { error } = await supabase
      .from('clients')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // LEADS CRUD
  static async getLeads(): Promise<types.Lead[]> {
    const { data, error } = await supabase
      .from('leads')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(transformDatabaseToApp.lead);
  }

  static async createLead(lead: Omit<types.Lead, 'id'>): Promise<types.Lead> {
    const { data, error } = await supabase
      .from('leads')
      .insert(transformAppToDatabase.lead(lead))
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.lead(data);
  }

  static async updateLead(id: string, updates: Partial<types.Lead>): Promise<types.Lead> {
    const { data, error } = await supabase
      .from('leads')
      .update(transformAppToDatabase.lead(updates as Omit<types.Lead, 'id'>))
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.lead(data);
  }

  static async deleteLead(id: string): Promise<void> {
    const { error } = await supabase
      .from('leads')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // PACKAGES CRUD
  static async getPackages(): Promise<types.Package[]> {
    const { data, error } = await supabase
      .from('packages')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(transformDatabaseToApp.package);
  }

  static async createPackage(pkg: Omit<types.Package, 'id'>): Promise<types.Package> {
    const { data, error } = await supabase
      .from('packages')
      .insert(transformAppToDatabase.package(pkg))
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.package(data);
  }

  static async updatePackage(id: string, updates: Partial<types.Package>): Promise<types.Package> {
    const { data, error } = await supabase
      .from('packages')
      .update(transformAppToDatabase.package(updates as Omit<types.Package, 'id'>))
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.package(data);
  }

  static async deletePackage(id: string): Promise<void> {
    const { error } = await supabase
      .from('packages')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // PROJECTS CRUD
  static async getProjects(): Promise<types.Project[]> {
    const { data, error } = await supabase
      .from('projects')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(transformDatabaseToApp.project);
  }

  static async createProject(project: Omit<types.Project, 'id'>): Promise<types.Project> {
    const { data, error } = await supabase
      .from('projects')
      .insert(transformAppToDatabase.project(project))
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.project(data);
  }

  static async updateProject(id: string, updates: Partial<types.Project>): Promise<types.Project> {
    const { data, error } = await supabase
      .from('projects')
      .update(transformAppToDatabase.project(updates as Omit<types.Project, 'id'>))
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return transformDatabaseToApp.project(data);
  }

  static async deleteProject(id: string): Promise<void> {
    const { error } = await supabase
      .from('projects')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // ADD-ONS CRUD
  static async getAddOns(): Promise<types.AddOn[]> {
    const { data, error } = await supabase
      .from('add_ons')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(item => ({
      id: item.id,
      name: item.name,
      price: Number(item.price)
    }));
  }

  static async createAddOn(addOn: Omit<types.AddOn, 'id'>): Promise<types.AddOn> {
    const { data, error } = await supabase
      .from('add_ons')
      .insert({ name: addOn.name, price: addOn.price })
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      name: data.name,
      price: Number(data.price)
    };
  }

  static async updateAddOn(id: string, updates: Partial<types.AddOn>): Promise<types.AddOn> {
    const { data, error } = await supabase
      .from('add_ons')
      .update({ name: updates.name, price: updates.price })
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      name: data.name,
      price: Number(data.price)
    };
  }

  static async deleteAddOn(id: string): Promise<void> {
    const { error } = await supabase
      .from('add_ons')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // TEAM MEMBERS CRUD
  static async getTeamMembers(): Promise<types.TeamMember[]> {
    const { data, error } = await supabase
      .from('team_members')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(member => ({
      id: member.id,
      name: member.name,
      role: member.role,
      email: member.email,
      phone: member.phone,
      standardFee: Number(member.standard_fee),
      noRek: member.no_rek,
      rewardBalance: Number(member.reward_balance),
      rating: Number(member.rating),
      performanceNotes: member.performance_notes as types.PerformanceNote[],
      portalAccessId: member.portal_access_id,
    }));
  }

  static async createTeamMember(member: Omit<types.TeamMember, 'id'>): Promise<types.TeamMember> {
    const { data, error } = await supabase
      .from('team_members')
      .insert({
        name: member.name,
        role: member.role,
        email: member.email,
        phone: member.phone,
        standard_fee: member.standardFee,
        no_rek: member.noRek,
        reward_balance: member.rewardBalance,
        rating: member.rating,
        performance_notes: member.performanceNotes,
        portal_access_id: member.portalAccessId,
      })
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      name: data.name,
      role: data.role,
      email: data.email,
      phone: data.phone,
      standardFee: Number(data.standard_fee),
      noRek: data.no_rek,
      rewardBalance: Number(data.reward_balance),
      rating: Number(data.rating),
      performanceNotes: data.performance_notes as types.PerformanceNote[],
      portalAccessId: data.portal_access_id,
    };
  }

  static async updateTeamMember(id: string, updates: Partial<types.TeamMember>): Promise<types.TeamMember> {
    const { data, error } = await supabase
      .from('team_members')
      .update({
        name: updates.name,
        role: updates.role,
        email: updates.email,
        phone: updates.phone,
        standard_fee: updates.standardFee,
        no_rek: updates.noRek,
        reward_balance: updates.rewardBalance,
        rating: updates.rating,
        performance_notes: updates.performanceNotes,
        portal_access_id: updates.portalAccessId,
      })
      .eq('id', id)
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      name: data.name,
      role: data.role,
      email: data.email,
      phone: data.phone,
      standardFee: Number(data.standard_fee),
      noRek: data.no_rek,
      rewardBalance: Number(data.reward_balance),
      rating: Number(data.rating),
      performanceNotes: data.performance_notes as types.PerformanceNote[],
      portalAccessId: data.portal_access_id,
    };
  }

  static async deleteTeamMember(id: string): Promise<void> {
    const { error } = await supabase
      .from('team_members')
      .delete()
      .eq('id', id);
    
    if (error) throw error;
  }

  // Continue with other CRUD operations...
  // For brevity, I'll implement a few more key ones
  
  // TRANSACTIONS CRUD
  static async getTransactions(): Promise<types.Transaction[]> {
    const { data, error } = await supabase
      .from('transactions')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(transaction => ({
      id: transaction.id,
      date: transaction.date,
      description: transaction.description,
      amount: Number(transaction.amount),
      type: transaction.type as types.TransactionType,
      projectId: transaction.project_id,
      category: transaction.category,
      method: transaction.method as 'Transfer Bank' | 'Tunai' | 'E-Wallet' | 'Sistem' | 'Kartu',
      pocketId: transaction.pocket_id,
      cardId: transaction.card_id,
      printingItemId: transaction.printing_item_id,
      vendorSignature: transaction.vendor_signature,
    }));
  }

  static async createTransaction(transaction: Omit<types.Transaction, 'id'>): Promise<types.Transaction> {
    const { data, error } = await supabase
      .from('transactions')
      .insert({
        date: transaction.date,
        description: transaction.description,
        amount: transaction.amount,
        type: transaction.type,
        project_id: transaction.projectId,
        category: transaction.category,
        method: transaction.method,
        pocket_id: transaction.pocketId,
        card_id: transaction.cardId,
        printing_item_id: transaction.printingItemId,
        vendor_signature: transaction.vendorSignature,
      })
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      date: data.date,
      description: data.description,
      amount: Number(data.amount),
      type: data.type as types.TransactionType,
      projectId: data.project_id,
      category: data.category,
      method: data.method as 'Transfer Bank' | 'Tunai' | 'E-Wallet' | 'Sistem' | 'Kartu',
      pocketId: data.pocket_id,
      cardId: data.card_id,
      printingItemId: data.printing_item_id,
      vendorSignature: data.vendor_signature,
    };
  }

  // FINANCIAL POCKETS CRUD
  static async getFinancialPockets(): Promise<types.FinancialPocket[]> {
    const { data, error } = await supabase
      .from('financial_pockets')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(pocket => ({
      id: pocket.id,
      name: pocket.name,
      description: pocket.description,
      icon: pocket.icon as 'piggy-bank' | 'lock' | 'users' | 'clipboard-list' | 'star',
      type: pocket.type as types.PocketType,
      amount: Number(pocket.amount),
      goalAmount: pocket.goal_amount ? Number(pocket.goal_amount) : undefined,
      lockEndDate: pocket.lock_end_date,
      members: pocket.members as types.TeamMember[],
      sourceCardId: pocket.source_card_id,
    }));
  }

  // CARDS CRUD
  static async getCards(): Promise<types.Card[]> {
    const { data, error } = await supabase
      .from('cards')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(card => ({
      id: card.id,
      cardHolderName: card.card_holder_name,
      bankName: card.bank_name,
      cardType: card.card_type as types.CardType,
      lastFourDigits: card.last_four_digits,
      expiryDate: card.expiry_date,
      balance: Number(card.balance),
      colorGradient: card.color_gradient,
    }));
  }

  // PROFILE CRUD
  static async getProfile(): Promise<types.Profile | null> {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .single();
    
    if (error) {
      if (error.code === 'PGRST116') return null; // No rows returned
      throw error;
    }
    
    return {
      id: data.id,
      adminUserId: data.admin_user_id,
      fullName: data.full_name,
      email: data.email,
      phone: data.phone,
      companyName: data.company_name,
      website: data.website,
      address: data.address,
      bankAccount: data.bank_account,
      authorizedSigner: data.authorized_signer,
      idNumber: data.id_number,
      bio: data.bio,
      incomeCategories: data.income_categories,
      expenseCategories: data.expense_categories,
      projectTypes: data.project_types,
      eventTypes: data.event_types,
      assetCategories: data.asset_categories,
      sopCategories: data.sop_categories,
      packageCategories: data.package_categories,
      projectStatusConfig: data.project_status_config as types.ProjectStatusConfig[],
      notificationSettings: data.notification_settings as types.NotificationSettings,
      securitySettings: data.security_settings as types.SecuritySettings,
      briefingTemplate: data.briefing_template,
      termsAndConditions: data.terms_and_conditions,
      contractTemplate: data.contract_template,
      logoBase64: data.logo_base64,
      brandColor: data.brand_color,
      publicPageConfig: data.public_page_config as types.PublicPageConfig,
      packageShareTemplate: data.package_share_template,
      bookingFormTemplate: data.booking_form_template,
      chatTemplates: data.chat_templates as types.ChatTemplate[],
    };
  }

  static async updateProfile(updates: Partial<types.Profile>): Promise<types.Profile> {
    const { data, error } = await supabase
      .from('profiles')
      .update({
        full_name: updates.fullName,
        email: updates.email,
        phone: updates.phone,
        company_name: updates.companyName,
        website: updates.website,
        address: updates.address,
        bank_account: updates.bankAccount,
        authorized_signer: updates.authorizedSigner,
        id_number: updates.idNumber,
        bio: updates.bio,
        income_categories: updates.incomeCategories,
        expense_categories: updates.expenseCategories,
        project_types: updates.projectTypes,
        event_types: updates.eventTypes,
        asset_categories: updates.assetCategories,
        sop_categories: updates.sopCategories,
        package_categories: updates.packageCategories,
        project_status_config: updates.projectStatusConfig,
        notification_settings: updates.notificationSettings,
        security_settings: updates.securitySettings,
        briefing_template: updates.briefingTemplate,
        terms_and_conditions: updates.termsAndConditions,
        contract_template: updates.contractTemplate,
        logo_base64: updates.logoBase64,
        brand_color: updates.brandColor,
        public_page_config: updates.publicPageConfig,
        package_share_template: updates.packageShareTemplate,
        booking_form_template: updates.bookingFormTemplate,
        chat_templates: updates.chatTemplates,
      })
      .select()
      .single();
    
    if (error) throw error;
    
    return {
      id: data.id,
      adminUserId: data.admin_user_id,
      fullName: data.full_name,
      email: data.email,
      phone: data.phone,
      companyName: data.company_name,
      website: data.website,
      address: data.address,
      bankAccount: data.bank_account,
      authorizedSigner: data.authorized_signer,
      idNumber: data.id_number,
      bio: data.bio,
      incomeCategories: data.income_categories,
      expenseCategories: data.expense_categories,
      projectTypes: data.project_types,
      eventTypes: data.event_types,
      assetCategories: data.asset_categories,
      sopCategories: data.sop_categories,
      packageCategories: data.package_categories,
      projectStatusConfig: data.project_status_config as types.ProjectStatusConfig[],
      notificationSettings: data.notification_settings as types.NotificationSettings,
      securitySettings: data.security_settings as types.SecuritySettings,
      briefingTemplate: data.briefing_template,
      termsAndConditions: data.terms_and_conditions,
      contractTemplate: data.contract_template,
      logoBase64: data.logo_base64,
      brandColor: data.brand_color,
      publicPageConfig: data.public_page_config as types.PublicPageConfig,
      packageShareTemplate: data.package_share_template,
      bookingFormTemplate: data.booking_form_template,
      chatTemplates: data.chat_templates as types.ChatTemplate[],
    };
  }

  // USERS CRUD
  static async getUsers(): Promise<types.User[]> {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    return data.map(user => ({
      id: user.id,
      email: user.email,
      password: user.password,
      fullName: user.full_name,
      companyName: user.company_name,
      role: user.role as 'Admin' | 'Member',
      permissions: user.permissions as types.ViewType[],
    }));
  }

  static async createUser(user: Omit<types.User, 'id'>): Promise<types.User> {
    const { data, error } = await supabase
      .from('users')
      .insert({
        email: user.email,
        password: user.password,
        full_name: user.fullName,
        company_name: user.companyName,
        role: user.role,
        permissions: user.permissions,
      })
      .select()
      .single();
    
    if (error) throw error;
    return {
      id: data.id,
      email: data.email,
      password: data.password,
      fullName: data.full_name,
      companyName: data.company_name,
      role: data.role as 'Admin' | 'Member',
      permissions: data.permissions as types.ViewType[],
    };
  }

  // ... implement other CRUD operations for remaining entities
  // (SOPs, Assets, Contracts, Promo Codes, Notifications, etc.)
}
