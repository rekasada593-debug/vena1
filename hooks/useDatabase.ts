
import { useState } from 'react';
import { DatabaseService } from '../services/database';
import * as types from '../types';

export const useDatabase = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleAsync = async <T>(operation: () => Promise<T>): Promise<T | null> => {
    setIsLoading(true);
    setError(null);
    try {
      const result = await operation();
      return result;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      console.error('Database operation failed:', err);
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  // Client operations
  const createClient = async (client: Omit<types.Client, 'id'>) => {
    return handleAsync(() => DatabaseService.createClient(client));
  };

  const updateClient = async (id: string, updates: Partial<types.Client>) => {
    return handleAsync(() => DatabaseService.updateClient(id, updates));
  };

  const deleteClient = async (id: string) => {
    return handleAsync(() => DatabaseService.deleteClient(id));
  };

  // Lead operations
  const createLead = async (lead: Omit<types.Lead, 'id'>) => {
    return handleAsync(() => DatabaseService.createLead(lead));
  };

  const updateLead = async (id: string, updates: Partial<types.Lead>) => {
    return handleAsync(() => DatabaseService.updateLead(id, updates));
  };

  const deleteLead = async (id: string) => {
    return handleAsync(() => DatabaseService.deleteLead(id));
  };

  // Project operations
  const createProject = async (project: Omit<types.Project, 'id'>) => {
    return handleAsync(() => DatabaseService.createProject(project));
  };

  const updateProject = async (id: string, updates: Partial<types.Project>) => {
    return handleAsync(() => DatabaseService.updateProject(id, updates));
  };

  const deleteProject = async (id: string) => {
    return handleAsync(() => DatabaseService.deleteProject(id));
  };

  // Package operations
  const createPackage = async (pkg: Omit<types.Package, 'id'>) => {
    return handleAsync(() => DatabaseService.createPackage(pkg));
  };

  const updatePackage = async (id: string, updates: Partial<types.Package>) => {
    return handleAsync(() => DatabaseService.updatePackage(id, updates));
  };

  const deletePackage = async (id: string) => {
    return handleAsync(() => DatabaseService.deletePackage(id));
  };

  // Add-on operations
  const createAddOn = async (addOn: Omit<types.AddOn, 'id'>) => {
    return handleAsync(() => DatabaseService.createAddOn(addOn));
  };

  const updateAddOn = async (id: string, updates: Partial<types.AddOn>) => {
    return handleAsync(() => DatabaseService.updateAddOn(id, updates));
  };

  const deleteAddOn = async (id: string) => {
    return handleAsync(() => DatabaseService.deleteAddOn(id));
  };

  // Team member operations
  const createTeamMember = async (member: Omit<types.TeamMember, 'id'>) => {
    return handleAsync(() => DatabaseService.createTeamMember(member));
  };

  const updateTeamMember = async (id: string, updates: Partial<types.TeamMember>) => {
    return handleAsync(() => DatabaseService.updateTeamMember(id, updates));
  };

  const deleteTeamMember = async (id: string) => {
    return handleAsync(() => DatabaseService.deleteTeamMember(id));
  };

  // Profile operations
  const updateProfile = async (updates: Partial<types.Profile>) => {
    return handleAsync(() => DatabaseService.updateProfile(updates));
  };

  return {
    isLoading,
    error,
    // Client operations
    createClient,
    updateClient,
    deleteClient,
    // Lead operations
    createLead,
    updateLead,
    deleteLead,
    // Project operations
    createProject,
    updateProject,
    deleteProject,
    // Package operations
    createPackage,
    updatePackage,
    deletePackage,
    // Add-on operations
    createAddOn,
    updateAddOn,
    deleteAddOn,
    // Team member operations
    createTeamMember,
    updateTeamMember,
    deleteTeamMember,
    // Profile operations
    updateProfile,
  };
};
